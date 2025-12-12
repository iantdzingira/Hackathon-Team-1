//
//  SubmitFeedView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct SubmitUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var updateData = UpdateData()
    @State private var isSubmitting = false
    @State private var submissionSuccess = false
    @State private var showingCategoryAlert = false
    
    private func submitUpdate() {
        guard !updateData.description.isEmpty else { return }
        
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            submissionSuccess = true
            print("Submitting Update: \(updateData)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Update Classification") {
                    Picker("Update Type", selection: $updateData.type) {
                        ForEach(UpdateType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Priority Level", selection: $updateData.priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    
                    HStack {
                        Text("Category")
                        Spacer()
                        TextField("e.g. Technical, Hiring, Curriculum", text: $updateData.category)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Details & Description") {
                    Text("Description")
                        .font(.headline)
                    
                    TextEditor(text: $updateData.description)
                        .frame(height: 150)
                        .border(Color.gray.opacity(0.2))
                    
                    VStack(alignment: .leading) {
                        Text("Impact Score (1-5): **\(updateData.impactScore)**")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Slider(value: Binding(get: {
                            Double(updateData.impactScore)
                        }, set: {
                            updateData.impactScore = Int($0)
                        }), in: 1...5, step: 1)
                    }
                }
                
                Section("Scheduling & Attachments") {
                    Toggle("Set Optional Due Date?", isOn: $updateData.hasDueDate.animation())
                    
                    if updateData.hasDueDate {
                        DatePicker("Target Completion", selection: $updateData.optionalDueDate, displayedComponents: .date)
                    }
                    
                    Button {
                        print("Opening file importer...")
                    } label: {
                        HStack {
                            Image(systemName: "paperclip")
                            Text("Add Attachment (e.g., PDF, Image)")
                        }
                    }
                }
                
                Section {
                    Button(action: submitUpdate) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                            }
                            Text(isSubmitting ? "Submitting..." : "Submit Project Update")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(isSubmitting || updateData.description.isEmpty)
                }
            }
            .navigationTitle("New Project Update")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .alert("Success!", isPresented: $submissionSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your update has been submitted and is now visible in the Updates Feed.")
        }
    }
}

struct SubmitUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitUpdateView()
    }
}
