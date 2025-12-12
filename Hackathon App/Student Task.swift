//
//  Priority.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 12/12/2025.
//


//
//  StudentTasks.swift
//  Hackathon App
//
//  Created by Sarah  on 12/12/2025.
//

import SwiftUI
import Combine

// MARK: Data Structures
enum Priority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

// Task Model
struct StudentTask: Identifiable {
    let id = UUID()
    var name: String
    var submissionTime: Date
    var isCompleted: Bool = false
    var priority: Priority
}

// MARK: Theme Color Extension
extension Color {
    static let themeOrange = Color.orange
}

// MARK:  Main Dashboard View
struct StudentTaskDashboardView: View {
    @State private var tasks: [StudentTask] = []
    @State private var showingAddTaskSheet = false
    
    var activeTasks: [StudentTask] { tasks.filter { !$0.isCompleted } }
    var completedTasksCount: Int { tasks.filter { $0.isCompleted }.count }
    var overdueTasksCount: Int { tasks.filter { !$0.isCompleted && $0.submissionTime < Date() }.count }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 15) {
                        
                        // MARK: Summary Cards
                        HStack {
                            MetricCard(title: "Pending Tasks", value: activeTasks.count, icon: "list.bullet.clipboard.fill", color: .themeOrange)
                            MetricCard(title: "Overdue", value: overdueTasksCount, icon: "exclamationmark.triangle.fill", color: .themeOrange)
                            MetricCard(title: "Completed", value: completedTasksCount, icon: "checkmark.circle.fill", color: .themeOrange)
                        }
                        .padding(.horizontal)
                        
                        // MARK: Active Tasks List
                        VStack(alignment: .leading, spacing: 10) {
                            Text("My Tasks")
                                .font(.title2).fontWeight(.bold)
                                .padding(.horizontal)
                            
                            if activeTasks.isEmpty {
                                Text("No tasks added yet! Tap the '+' button to begin.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            } else {
                                ForEach($tasks.filter { !$0.wrappedValue.isCompleted }.sorted(by: { $0.wrappedValue.submissionTime < $1.wrappedValue.submissionTime })) { $task in
                                    TaskRow(task: $task)
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        // MARK: Completed Tasks
                        if completedTasksCount > 0 {
                            Divider().padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Completed Tasks")
                                    .font(.title2).fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                ForEach($tasks.filter { $0.wrappedValue.isCompleted }) { $task in
                                    TaskRow(task: $task)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
                .navigationTitle("My Tasks")
                
                // MARK: Floating Add Button
                Button {
                    showingAddTaskSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.themeOrange)
                        .shadow(radius: 5)
                }
                .padding()
            }
            .sheet(isPresented: $showingAddTaskSheet) {
                AddTaskSheetView(tasks: $tasks)
            }
        }
    }
}

// MARK:  Metric Card Component
struct MetricCard: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text("\(value)")
                .font(.title)
                .bold()
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK:  Task Row Component
struct TaskRow: View {
    @Binding var task: StudentTask
    @State private var timeRemaining: String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func updateTimeRemaining() {
        guard !task.isCompleted else {
            timeRemaining = "Completed"
            return
        }
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: task.submissionTime)
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        if task.submissionTime < Date() {
            timeRemaining = "OVERDUE"
        } else if days > 0 {
            timeRemaining = "Left: \(days)d \(hours)h"
        } else if hours > 0 {
            timeRemaining = "Left: \(hours)h \(minutes)m"
        } else if minutes > 0 {
            timeRemaining = "Left: \(minutes)m"
        } else {
            timeRemaining = "Due Now!"
        }
    }
    
    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
                updateTimeRemaining()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isCompleted ? .themeOrange : .secondary)
            }.padding(.trailing, 5)
            
            VStack(alignment: .leading) {
                Text(task.name)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .font(.headline)
                
                HStack {
                    Text("\(task.submissionTime.formatted(date: .abbreviated, time: .shortened))")
                    
                    if !task.isCompleted && timeRemaining != "OVERDUE" {
                        Text(task.priority.rawValue)
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.themeOrange)
                            .cornerRadius(4)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            Spacer()
            
            Text(timeRemaining)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(timeRemaining == "OVERDUE" ? .white : .themeOrange)
                .padding(6)
                .background(timeRemaining == "OVERDUE" ? Color.red : Color(.systemGray6))
                .cornerRadius(6)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color(.black).opacity(0.05), radius: 2, x: 0, y: 1)
        .onAppear(perform: updateTimeRemaining)
        .onReceive(timer) { _ in updateTimeRemaining() }
    }
}

// MARK:  Add Task Sheet View
struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [StudentTask]
    
    @State private var taskName: String = ""
    @State private var submissionDateTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var priority: Priority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $taskName)
                    
                    DatePicker("Submission Date", selection: $submissionDateTime, displayedComponents: .date)
                    DatePicker("Submission Time", selection: $submissionDateTime, displayedComponents: .hourAndMinute)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                }
                
                Button("Save Task") {
                    saveTask()
                }
                .disabled(taskName.isEmpty || submissionDateTime < Date())
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func saveTask() {
        let newTask = StudentTask(name: taskName, submissionTime: submissionDateTime, priority: priority)
        tasks.append(newTask)
        dismiss()
    }
}

// MARK: Preview
struct StudentTaskDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        StudentTaskDashboardView()
    }
}
