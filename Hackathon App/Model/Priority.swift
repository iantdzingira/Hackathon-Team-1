//
//  Priority.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 18/12/2025.
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