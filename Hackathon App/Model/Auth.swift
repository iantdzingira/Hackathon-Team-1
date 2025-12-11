//
//  Auth.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import Foundation

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
