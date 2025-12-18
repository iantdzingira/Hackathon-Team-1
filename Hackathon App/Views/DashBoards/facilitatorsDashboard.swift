import SwiftUI
import Combine

struct FacilitatorsDashboard: View {
    @StateObject private var vm = DashboardVM()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            StudentListView(vm: vm)
                .tabItem {
                    Label("Students", systemImage: "person.3.fill")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            ClassUpdatesView(vm: vm)
                .tabItem {
                    Label("Updates", systemImage: "bell.badge.fill")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            AnalyticsView(vm: vm)
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie.fill")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
        }
        .tint(.orange)
    }
}



struct StudentRow: View {
    let student: Student
    
    var body: some View {
        HStack(spacing: 16) {
            // Status Indicator
            Circle()
                .fill(attendanceColor)
                .frame(width: 12, height: 12)
            
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                Text(String(student.name.prefix(1)))
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(student.name)
                        .font(.headline)
                    Spacer()
                    Text("\(Int(student.attendance * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(attendanceColor)
                }
                
                HStack {
                    Text(student.cohort)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(student.stage.rawValue)
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    var attendanceColor: Color {
        student.attendance > 0.8 ? .green : student.attendance > 0.7 ? .orange : .red
    }
}

struct StudentDetailView: View {
    let student: Student
    @ObservedObject var vm: DashboardVM
    @Environment(\.dismiss) var dismiss
    @State private var newNote = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Student Info") {
                    InfoRow(label: "Name", value: student.name)
                    InfoRow(label: "Cohort", value: student.cohort)
                    InfoRow(label: "Attendance", value: "\(Int(student.attendance * 100))%")
                    InfoRow(label: "Skill Level", value: "\(student.skill)/5")
                    InfoRow(label: "Stage", value: student.stage.rawValue)
                }
                
                Section("Add Note") {
                    TextField("Enter note for \(student.name)...", text: $newNote, axis: .vertical)
                        .lineLimit(3)
                    
                    Button("Save Note") {
                        if !newNote.isEmpty {
                            vm.addNote(to: student, note: newNote)
                            newNote = ""
                        }
                    }
                    .disabled(newNote.isEmpty)
                }
                
                if !student.notes.isEmpty {
                    Section("Recent Notes") {
                        ForEach(Array(student.notes.reversed().prefix(5)), id: \.self) { note in
                            Text(note)
                                .font(.caption)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Student Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body.monospacedDigit())
        }
    }
}

struct ClassUpdatesView: View {
    @ObservedObject var vm: DashboardVM
    @State private var newUpdate = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Professional Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Updates")
                            .font(.title.bold())
                        Text("\(vm.updates.count) announcements")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: {
                        if !newUpdate.isEmpty {
                            vm.addUpdate(newUpdate, isImportant: newUpdate.contains("!"))
                            newUpdate = ""
                        }
                    }) {
                        Label("Post", systemImage: "paperplane.fill")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .disabled(newUpdate.isEmpty)
                }
                .padding(.horizontal)
                .padding(.top)
                
                TextField("Post an update...", text: $newUpdate, axis: .vertical)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                List {
                    ForEach(vm.updates) { update in
                        UpdateRow(update: update)
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarHidden(true)
        }
    }
}

struct UpdateRow: View {
    let update: ClassUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if update.isImportant {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                }
                Text(update.text)
                    .font(.body)
                Spacer()
            }
            
            HStack {
                Text(update.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if update.isImportant {
                    Spacer()
                    Text("Important")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AddStudentView: View {
    @ObservedObject var vm: DashboardVM
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var cohort = ""
    @State private var attendance = 0.8
    @State private var skill = 3
    @State private var stage: StudentStage = .book1
    
    var body: some View {
        NavigationView {
            Form {
                Section("Student Details") {
                    TextField("Full Name", text: $name)
                    TextField("Cohort", text: $cohort)
                    VStack(alignment: .leading) {
                        Text("Attendance: \(Int(attendance * 100))%")
                        Slider(value: $attendance, in: 0...1, step: 0.05)
                    }
                    Stepper("Skill Level: \(skill)", value: $skill, in: 1...5)
                    Picker("Stage", selection: $stage) {
                        ForEach(StudentStage.allCases, id: \.self) { Text($0.rawValue) }
                    }
                }
            }
            .navigationTitle("Add Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        vm.addStudent(name: name, cohort: cohort, attendance: attendance, skill: skill, stage: stage)
                        dismiss()
                    }
                    .disabled(name.isEmpty || cohort.isEmpty)
                }
            }
        }
    }
}

#Preview {
    FacilitatorsDashboard()
}
