//
//  StudentStage.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 18/12/2025.
//

import SwiftUI
import Combine

enum StudentStage: String, CaseIterable {
    case book1 = "Swift Explorations", book2 = "Swift Fundamentals", internship = "Internship"
}

struct Student: Identifiable {
    let id = UUID()
    var name: String
    var cohort: String
    var attendance: Double
    var skill: Int
    var notes: [String] = []
    var stage: StudentStage
    var lastUpdated: Date = .now
    var isBookmarked: Bool = false
}

struct ClassUpdate: Identifiable {
    let id = UUID()
    var text: String
    var date: Date = .now
    var isImportant = false
}

class DashboardVM: ObservableObject {
    @Published var students: [Student] = []
    @Published var updates: [ClassUpdate] = [
        ClassUpdate(text: "Welcome to Classroom Dashboard", isImportant: true),
        ClassUpdate(text: "New attendance policy shared")
    ]
    @Published var search = ""
    @Published var selectedCohort = "All"
    @Published var selectedTab = 0
    
    var cohorts: [String] {
        ["All"] + Array(Set(students.map { $0.cohort })).sorted()
    }
    
    var filteredStudents: [Student] {
        students.filter { s in
            (selectedCohort == "All" || s.cohort == selectedCohort) &&
            (search.isEmpty || s.name.localizedCaseInsensitiveContains(search))
        }
    }
    
    func addNote(to student: Student, note: String) {
        guard let index = students.firstIndex(where: { $0.id == student.id }) else { return }
        students[index].notes.append(note)
        students[index].lastUpdated = .now
    }
    
    func addUpdate(_ text: String, isImportant: Bool = false) {
        updates.insert(ClassUpdate(text: text, isImportant: isImportant), at: 0)
    }
    
    func addStudent(name: String, cohort: String, attendance: Double, skill: Int, stage: StudentStage) {
        students.append(Student(name: name, cohort: cohort, attendance: attendance, skill: skill, stage: stage))
    }
    
    func deleteStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }
    
    func percentage(for stage: StudentStage) -> Double {
        guard !students.isEmpty else { return 0 }
        let count = students.filter { $0.stage == stage }.count
        return Double(count) / Double(students.count)
    }
    
    func overallAttendance() -> Double {
        guard !students.isEmpty else { return 0 }
        return students.reduce(0) { $0 + $1.attendance } / Double(students.count)
    }
}
