//
//  Dashboard.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//
import SwiftUI

struct RoleRouterView: View {
    let user: User
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch user.role {
        case .student:
            StudentsDashboard()
        case .manager:
            ManagersDashboard()
        case .projectManager:
            ProjectsView()
        case .donor:
            DonorSnapshot()
        case .facilitator:
            FacilitatorsDashboard()
        case .intern:
            InternsDashboard()
        case .hiringCompany:
            HiringCompaniesDashboard()
        case .none:
            Text("No role assigned.")
        }
    }
}
