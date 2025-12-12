//
//  HiringCompanies.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct TalentPipelineView: View {
    @StateObject var viewModel = TalentPipelineViewModel()
    @State private var showingFilters = true
    @State private var showingInterviewRequestSheet = false
    
    var body: some View {
        NavigationView {
            List {
                
                // MARK: 1. Filter Section (Collapsible)
                DisclosureGroup("Filter & Refine Pipeline", isExpanded: $showingFilters) {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Internship Status Filter
                        Picker("Status", selection: $viewModel.selectedStatusFilter) {
                            Text("All Statuses").tag(InternshipStatus?.none)
                            ForEach(InternshipStatus.allCases) { status in
                                Text(status.rawValue).tag(status as InternshipStatus?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        // Skill Score Filter (Slider)
                        VStack(alignment: .leading) {
                            Text("Minimum Skill Score: **\(Int(viewModel.minSkillScore)) / 5**")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Slider(value: $viewModel.minSkillScore, in: 1...5, step: 1)
                        }
                    }
                    .padding(.vertical)
                }
                .listRowBackground(Color(.systemGray6))
                
                // MARK: 2. Student List
                
                Section("Filtered Talent Pool (\(viewModel.filteredStudents.count) Candidates)") {
                    ForEach(viewModel.filteredStudents) { student in
                        NavigationLink {
                            StudentDetailForHiringView(student: student)
                        } label: {
                            StudentPipelineRow(student: student)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Talent Pipeline")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Request Interview") {
                        showingInterviewRequestSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showingInterviewRequestSheet) {
                InterviewRequestSheet()
            }
        }
    }
}

// MARK: - Sub-Views

// 2.1 Student Row
struct StudentPipelineRow: View {
    let student: StudentTalent
    
    private var readyColor: Color {
        student.isInterviewReady ? .green : .orange
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                Text(student.name)
                    .font(.headline)
                
                Text(student.cohort)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: student.isInterviewReady ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(readyColor)
                    Text(student.isInterviewReady ? "Ready" : "Review Needed")
                        .font(.subheadline)
                        .foregroundColor(readyColor)
                }
                Text("Skill: \(student.skillScore)/5")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 2.2 Student Detail View for Hiring
struct StudentDetailForHiringView: View {
    let student: StudentTalent
    
    var body: some View {
        List {
            Section("Summary") {
                HStack {
                    Text("Technical Skill")
                    Spacer()
                    Text("\(student.skillScore) / 5")
                }
                HStack {
                    Text("Attendance")
                    Spacer()
                    Text("\(Int(student.attendance * 100))%")
                }
                HStack {
                    Text("Internship Status")
                    Spacer()
                    Text(student.internshipStatus.rawValue)
                        .foregroundColor(student.internshipStatus == .placed ? .blue : .primary)
                }
            }
            
            Section("Facilitator Notes (Last 3)") {
                if student.facilitatorNotes.isEmpty {
                    Text("No recent performance notes available.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(student.facilitatorNotes.suffix(3), id: \.self) { note in
                    }
                }
            }
        }
        .navigationTitle(student.name)
        .toolbar {
            Button("Request Interview") {
                // Action to request interview for this specific student
            }
        }
    }
}

// 2.3 Interview Request Form (Sheet)
struct InterviewRequestSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedStudents: Set<UUID> = []
    @State private var availableStudents: [StudentTalent] = StudentTalent.mockStudents.filter { $0.isInterviewReady && $0.internshipStatus == .available }
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Select Candidates") {
                    if availableStudents.isEmpty {
                        Text("No eligible students currently marked as Interview Ready and Available.")
                    } else {
                        List {
                            ForEach(availableStudents) { student in
                                MultipleSelectionRow(title: student.name, isSelected: selectedStudents.contains(student.id)) {
                                    if selectedStudents.contains(student.id) {
                                        selectedStudents.remove(student.id)
                                    } else {
                                        selectedStudents.insert(student.id)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Details") {
                    TextField("Hiring Manager Contact", text: .constant("")) // Placeholder
                    TextEditor(text: $message)
                        .frame(height: 100)
                        .overlay(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Add specific roles or interview requirements...")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                        }
                }
                
                Button("Submit Interview Request") {
                    // Placeholder for submission logic
                    print("Requesting interviews for: \(selectedStudents)")
                    dismiss()
                }
                .disabled(selectedStudents.isEmpty)
            }
            .navigationTitle("Request Interviews")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// Helper for multi-selection in a List
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundColor(.primary)
    }
}

// Preview Provider
struct TalentPipelineView_Previews: PreviewProvider {
    static var previews: some View {
        TalentPipelineView()
    }
}
