//
//  MasterProjectReportingView.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 12/12/2025.
//
import SwiftUI
import Combine

struct MasterProjectReportingView: View {
    @StateObject var viewModel = MasterPMViewModel()
    @State private var showingExportAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // MARK: 1. Project Health Summary
                Section(header: Text("Project Health Snapshot")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.globalProjectHealth, id: \.name) { health in
                                ProjectHealthCard(health: health)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .listRowBackground(Color.clear)
                }
                
                // MARK: 2. Needs Attention (Critical, Auto-Generated List)
                Section(header: Text("🚨 Needs Attention (\(viewModel.needsAttentionUpdates.count) Critical Items)")) {
                    if viewModel.needsAttentionUpdates.isEmpty {
                        Text("All critical issues resolved! Project is Green.")
                            .foregroundColor(.green)
                    } else {
                        ForEach(viewModel.needsAttentionUpdates.prefix(3)) { update in
                            NavigationLink {
                                UpdateDetailView(update: update)
                            } label: {
                                NeedsAttentionRow(update: update)
                            }
                        }
                        
                        // Option to view all
                        if viewModel.needsAttentionUpdates.count > 3 {
                            Button("View All \(viewModel.needsAttentionUpdates.count) Critical Updates") {
                                viewModel.urgencyFilter = .urgent // Focuses the lower list on urgent
                            }
                        }
                    }
                }
                
                // MARK: 3. Detailed Updates & Filters
                Section(header: Text("All Project Updates")) {
                    
                    // Filter Controls
                    HStack {
                        Picker("Project", selection: $viewModel.selectedProjectFilter) {
                            Text("All Projects").tag(String?.none)
                            ForEach(viewModel.uniqueProjects, id: \.self) { project in
                                Text(project).tag(project as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Urgency", selection: $viewModel.urgencyFilter) {
                            Text("All Urgency").tag(Priority?.none)
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority as Priority?)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    // Filtered List
                    ForEach(viewModel.filteredUpdates) { update in
                        NavigationLink {
                            UpdateDetailView(update: update)
                        } label: {
                            UpdateRow(update: update)
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Master Reporting")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingExportAlert = true
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .alert("Export Options", isPresented: $showingExportAlert) {
            Button("Export to PDF", action: {})
            Button("Generate Weekly Summary Email", action: {})
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose your preferred report format.")
        }
    }
}

// MARK: - Sub-Views

struct ProjectHealthCard: View {
    let health: (name: String, blockers: Int, completion: Double)
    
    // Determine card color based on completion and blockers
    private var healthColor: Color {
        if health.blockers > 2 || health.completion < 0.6 {
            return .red // Critical
        } else if health.blockers > 0 || health.completion < 0.9 {
            return .orange // Warning
        } else {
            return .green // Green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(health.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                Text("\(Int(health.completion * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: health.blockers > 0 ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(healthColor)
            }
            
            Text("\(health.blockers) Active Blockers")
                .font(.subheadline)
                .foregroundColor(healthColor)
            
            ProgressView(value: health.completion)
                .tint(healthColor)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: 200)
    }
}

struct NeedsAttentionRow: View {
    let update: ProjectUpdate
    
    var body: some View {
        HStack {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
            
            VStack(alignment: .leading) {
                Text(update.description)
                    .lineLimit(1)
                    .font(.headline)
                Text("\(update.project) • \(update.submitter) • \(update.date, style: .relative)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Preview Provider
struct MasterProjectReportingView_Previews: PreviewProvider {
    static var previews: some View {
        MasterProjectReportingView()
    }
}
