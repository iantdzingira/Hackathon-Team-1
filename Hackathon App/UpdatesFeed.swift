//
//  UpdatesFeed.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct UpdatesFeedView: View {
    @StateObject var viewModel = UpdatesFeedViewModel()
    
    // Get all unique update types for the filter picker
    var allUpdateTypes: [UpdateType?] {
        [.none] + UpdateType.allCases
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(allUpdateTypes, id: \.self) { type in
                            Button {
                                viewModel.selectedFilter = type
                            } label: {
                                Text(type?.rawValue ?? "All Updates")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(type == viewModel.selectedFilter ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(type == viewModel.selectedFilter ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground)) // Keeps bar visible over list
                
                // --- List/Feed ---
                List {
                    if viewModel.filteredUpdates.isEmpty {
                        VStack(alignment: .center) {
                            Text("No Updates Found")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text("Try adjusting your filters or search terms.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                        .listRowSeparator(.hidden)
                    }
                    
                    ForEach(viewModel.filteredUpdates) { update in
                        // Wrap the row in a NavigationLink to enable tapping for details
                        NavigationLink {
                            UpdateDetailView(update: update) // Detail view needed next
                        } label: {
                            UpdateRow(update: update)
                        }
                    }
                }
                .listStyle(.plain) // Use plain style for a cleaner, modern feed look
                .searchable(text: $viewModel.searchText, prompt: "Search by keyword, submitter, or category")
            }
            .navigationTitle("Updates Feed")
        }
    }
}

// MARK: - UpdateDetailView (Placeholder)

// Required to make the NavigationLink functional
struct UpdateDetailView: View {
    let update: ProjectUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(update.type.rawValue)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Divider()
            
            Group {
                // More detailed view of all the update's fields
                UpdateDetailRow(title: "Project", value: update.project)
                UpdateDetailRow(title: "Category", value: update.category)
                UpdateDetailRow(title: "Priority", value: update.priority.rawValue)
                UpdateDetailRow(title: "Submitted By", value: update.submitter)
                UpdateDetailRow(title: "Date", value: update.date.formatted(date: .abbreviated, time: .shortened))
            }
            
            Text("Description")
                .font(.headline)
                .padding(.top, 10)
            
            Text(update.description)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Update Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Simple helper for detail view layout
struct UpdateDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct UpdateRow: View {
    let update: ProjectUpdate
    
    // Determine color based on priority
    private var priorityColor: Color {
        switch update.priority {
        case .urgent: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return .green
        }
    }
    
    // Determine icon based on type
    private var iconName: String {
        switch update.type {
        case .blocker: return "exclamationmark.triangle.fill"
        case .milestone: return "flag.checkered.2.fill"
        case .progress: return "arrow.up.circle.fill"
        case .requestHelp: return "questionmark.circle.fill"
        case .studentNote: return "person.text.rectangle.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Priority Tag and Project Name
            HStack {
                Text(update.priority.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(priorityColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.15))
                    .cornerRadius(5)
                
                Spacer()
                Text(update.project)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Title/Type
            HStack(alignment: .top) {
                Image(systemName: iconName)
                    .foregroundColor(priorityColor)
                    .font(.title3)
                
                VStack(alignment: .leading) {
                    Text(update.type.rawValue)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(update.description)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2) // Show snippet of the description
                }
            }
            
            // Submitter and Date/Category
            HStack {
                Text("By \(update.submitter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("#\(update.category)")
                    .font(.caption)
                    .foregroundColor(.blue)

                Text(update.date, style: .relative) // e.g., 2 hours ago
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct UpdatesFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatesFeedView()
    }
}
