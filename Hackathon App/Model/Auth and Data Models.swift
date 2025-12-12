//
//  Auth.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import Foundation
import SwiftUI
import Combine

enum Role: String, Codable {
    case student = "student"
    case donor = "donor"
    case facilitator = "facilitator"
    case projectManager = "project manager"
    case intern = "intern"
    case hiringCompany = "hiring company"
    case manager = "manager"
    
    var capitalizedName: String {
        switch self {
        case .projectManager: return "Project Manager"
        case .hiringCompany: return "Hiring Company"
        default: return self.rawValue.capitalized
        }
    }
}

struct User: Codable, Identifiable {
    let id: UUID = UUID()
    
    let email: String
    let password: String
    let role: Role?
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case role
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.role = try container.decodeIfPresent(Role.self, forKey: .role)
    }
    
    // Initializer for Sign In (Role is not required in request payload)
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.role = nil
    }
    
    // Initializer for Sign Up (Role is required)
    init(email: String, password: String, role: Role) {
        self.email = email
        self.password = password
        self.role = role
    }
}

//

enum UpdateType: String, CaseIterable, Identifiable {
    case progress = "Progress Update"
    case blocker = "Blocker/Issue"
    case milestone = "Completed Milestone"
    case studentNote = "Student Performance Note"
    case requestHelp = "Request for Help"
    var id: String { self.rawValue }
}

enum Priority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    var id: String { self.rawValue }
}

// MARK: - Form Data Model

struct UpdateData {
    var type: UpdateType = .progress
    var priority: Priority = .medium
    var category: String = "General"
    var description: String = ""
    var impactScore: Int = 1
    var optionalDueDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    var hasDueDate: Bool = false
}


struct ProjectUpdate: Identifiable {
    let id = UUID()
    let type: UpdateType
    let priority: Priority
    let category: String
    let description: String
    let submitter: String
    let date: Date
    let project: String
}

// MARK: - Data Source (For Hackathon Simplicity)

class UpdatesFeedViewModel: ObservableObject {
    @Published var updates: [ProjectUpdate] = []
    @Published var selectedFilter: UpdateType? = nil // Nil means show all
    @Published var searchText: String = ""
    
    init() {
        self.updates = MockData.sampleUpdates.sorted(by: { $0.date > $1.date }) // Sort newest first
    }
    
    var filteredUpdates: [ProjectUpdate] {
        updates.filter { update in
            let matchesFilter = selectedFilter == nil || update.type == selectedFilter
            let matchesSearch = searchText.isEmpty ||
                update.description.localizedCaseInsensitiveContains(searchText) ||
                update.submitter.localizedCaseInsensitiveContains(searchText) ||
                update.category.localizedCaseInsensitiveContains(searchText) ||
                update.project.localizedCaseInsensitiveContains(searchText)
            
            return matchesFilter && matchesSearch
        }
    }
}

// MARK: - Mock Data

struct MockData {
    static let sampleUpdates: [ProjectUpdate] = [
        ProjectUpdate(type: .blocker, priority: .urgent, category: "Technical", description: "Zim server deployment failed due to missing Docker image dependency.", submitter: "Langa Dube (PM)", date: Date().addingTimeInterval(-3600), project: "MCRI 2.0"),
        ProjectUpdate(type: .milestone, priority: .medium, category: "Curriculum", description: "Module 3: Swift Fundamentals completed by 95% of students.", submitter: "Sipho Nyathi (Facilitator)", date: Date().addingTimeInterval(-10800), project: "MCRI 2.0"),
        ProjectUpdate(type: .requestHelp, priority: .high, category: "Hiring", description: "Need US Manager review on the new Intern placement criteria for TechCorp.", submitter: "Jane Doe (Manager)", date: Date().addingTimeInterval(-86400), project: "Global Ops"),
        ProjectUpdate(type: .progress, priority: .low, category: "General", description: "Weekly sync meeting concluded. All teams are green for next week.", submitter: "Zim Manager", date: Date().addingTimeInterval(-172800), project: "MCRI 2.0"),
        ProjectUpdate(type: .studentNote, priority: .medium, category: "Performance", description: "Student M. Moyo showed significant improvement in debugging logic this week.", submitter: "Facilitator A", date: Date().addingTimeInterval(-259200), project: "MCRI 2.0"),
    ]
}

class MasterPMViewModel: ObservableObject {
    @Published var allUpdates: [ProjectUpdate] = MockData.sampleUpdates // Inherit all updates
    @Published var selectedProjectFilter: String? = nil // Global project filter
    @Published var urgencyFilter: Priority? = .urgent // Default focus on urgent issues
    
    // Computed property 1: Auto-Generated "Needs Attention" List
    var needsAttentionUpdates: [ProjectUpdate] {
        allUpdates
            .filter { update in
                // A blocker or a high/urgent request that hasn.t been addressed
                return update.type == .blocker || update.priority == .urgent || update.priority == .high
            }
            .sorted(by: { $0.priority.rawValue > $1.priority.rawValue }) // Urgent first
    }
    
    // Computed property 2: Filtered List for General Reporting (based on selected filters)
    var filteredUpdates: [ProjectUpdate] {
        allUpdates.filter { update in
            let projectMatches = selectedProjectFilter == nil || update.project == selectedProjectFilter
            let urgencyMatches = urgencyFilter == nil || update.priority == urgencyFilter
            
            return projectMatches && urgencyMatches
        }
    }
    
    // For the filter picker
    var uniqueProjects: [String] {
        var projects = Set(allUpdates.map { $0.project })
        return Array(projects).sorted()
    }
    
    // Placeholder for a detailed project health summary
    var globalProjectHealth: [(name: String, blockers: Int, completion: Double)] {
        return [
            ("MCRI 2.0", blockers: 1, completion: 0.85),
            ("Global Ops", blockers: 0, completion: 0.95),
            ("Zim Hiring Q4", blockers: 3, completion: 0.50)
        ]
    }
}

struct StudentTalent: Identifiable {
    let id = UUID()
    let name: String
    let cohort: String
    var skillScore: Int // 1-5 rating, e.g., Technical Proficiency
    var attendance: Double // 0.0 - 1.0
    var internshipStatus: InternshipStatus
    var facilitatorNotes: [String]
    var isInterviewReady: Bool // Computed status based on score/attendance
}

enum InternshipStatus: String, CaseIterable, Identifiable {
    case available = "Available"
    case pendingInterview = "Pending Interview"
    case placed = "Placed (In Progress)"
    case completed = "Completed"
    var id: String { self.rawValue }
}

// MARK: - Mock Data for Pipeline

extension StudentTalent {
    static let mockStudents: [StudentTalent] = [
        StudentTalent(name: "Aisha M", cohort: "C2025-Zim", skillScore: 5, attendance: 0.98, internshipStatus: .available, facilitatorNotes: ["Exceptional Swift knowledge.", "Strong independent debugger."], isInterviewReady: true),
        StudentTalent(name: "Brian K", cohort: "C2025-Zim", skillScore: 4, attendance: 0.90, internshipStatus: .pendingInterview, facilitatorNotes: ["Needs slight polish on communication.", "Met all Module 4 milestones."], isInterviewReady: true),
        StudentTalent(name: "Chloe V", cohort: "C2024-US", skillScore: 3, attendance: 0.85, internshipStatus: .placed, facilitatorNotes: ["Requires support in project planning.", "Attendance flagged twice."], isInterviewReady: false),
        StudentTalent(name: "David N", cohort: "C2025-Zim", skillScore: 5, attendance: 1.0, internshipStatus: .completed, facilitatorNotes: ["Top performer. Highly recommended."], isInterviewReady: true)
    ]
}

// MARK: - View Model

class TalentPipelineViewModel: ObservableObject {
    @Published var students: [StudentTalent] = StudentTalent.mockStudents
    @Published var selectedStatusFilter: InternshipStatus? = .available
    @Published var minSkillScore: Double = 3.0
    
    var filteredStudents: [StudentTalent] {
        students.filter { student in
            let statusMatches = selectedStatusFilter == nil || student.internshipStatus == selectedStatusFilter
            let skillMatches = student.skillScore >= Int(minSkillScore)
            return statusMatches && skillMatches
        }
        .sorted { $0.skillScore > $1.skillScore }
    }
}
