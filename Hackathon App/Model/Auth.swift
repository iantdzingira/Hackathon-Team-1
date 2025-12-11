//
//  Auth.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import Foundation

struct User: Codable, Identifiable {
    var id = UUID()
    let email: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
