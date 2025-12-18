//
//  StudentListView.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 18/12/2025.
//

import SwiftUI

struct StudentListView: View {
    @ObservedObject var vm: DashboardVM
    @State private var showingAddStudent = false
    @State private var selectedStudent: Student?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Students")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                        Text("\(vm.filteredStudents.count) enrolled")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Menu {
                        ForEach(vm.cohorts, id: \.self) { cohort in
                            Button(cohort) { vm.selectedCohort = cohort }
                        }
                    } label: {
                        HStack {
                            Text(vm.selectedCohort)
                                .font(.subheadline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: { showingAddStudent = true }) {
                        Image(systemName: "person.badge.plus")
                            .font(.body.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                List {
                    ForEach(vm.filteredStudents) { student in
                        StudentRow(student: student)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    if let index = vm.students.firstIndex(where: { $0.id == student.id }) {
                                        vm.students.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    selectedStudent = student
                                } label: {
                                    Label("Details", systemImage: "info.circle")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $vm.search, prompt: "Search by name...")
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddStudent) {
            AddStudentView(vm: vm)
        }
        .sheet(item: $selectedStudent) { student in
            StudentDetailView(student: student, vm: vm)
        }
    }
}
