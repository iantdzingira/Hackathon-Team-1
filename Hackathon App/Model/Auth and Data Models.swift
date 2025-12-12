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

struct Project: Identifiable {
    let id = UUID()
    let name: String
    let status: ProjectStatus
    let progress: Double
    let teamSize: Int
}

enum ProjectStatus: String {
    case green = "On Track"
    case yellow = "At Risk"
    case red = "Late"
    
    var color: Color {
        switch self {
        case .green: return .green
        case .yellow: return .orange
        case .red: return .red
        }
    }
}

struct Milestone: Identifiable {
    let id = UUID()
    let name: String
    let dueDate: Date
    let status: ProjectStatus
}

struct Kpi: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let target: Double
    let unit: String
}

struct StakeholderNote: Identifiable {
    let id = UUID()
    let author: String
    let content: String
    let date: Date
}

let sampleProjects: [Project] = [
    Project(name: "Internal Data API v2", status: .green, progress: 0.75, teamSize: 5),
    Project(name: "MCRI Website Redesign", status: .yellow, progress: 0.50, teamSize: 3),
    Project(name: "Patient Portal Login Fix", status: .red, progress: 0.20, teamSize: 1),
    Project(name: "Hiring Pipeline Dashboard", status: .green, progress: 0.90, teamSize: 2),
    Project(name: "Mobile App Testing", status: .yellow, progress: 0.85, teamSize: 4),
    Project(name: "Server Migration Prep", status: .green, progress: 1.00, teamSize: 2)
]

let sampleTasks = [2, 22, 51, 30, 15, 8]

let sampleMilestones: [Milestone] = [
    Milestone(name: "Elevator Installation", dueDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, status: .green),
    Milestone(name: "Hackathon Finishing", dueDate: Date(), status: .yellow),
    Milestone(name: "Swift Updates", dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!, status: .red),
    Milestone(name: "Sign Language App Final Deployment", dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!, status: .red)
]

let sampleKpis: [Kpi] = [
    Kpi(name: "Open Critical Issues", value: 3.0, target: 1.0, unit: "Issues"),
    Kpi(name: "Test Coverage", value: 0.65, target: 0.80, unit: "%"),
    Kpi(name: "Team Velocity", value: 18.0, target: 20.0, unit: "Points")
]

let sampleNotes: [StakeholderNote] = [
    StakeholderNote(author: "Dr. Smith (Sponsor)", content: "Concerned about the dependency on the IT team for server access. This is a critical path risk.", date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!),
    StakeholderNote(author: "Lead Developer", content: "Architecture review passed successfully. Starting sprint 2 planning.", date: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!)
]
