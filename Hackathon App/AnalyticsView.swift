//
//  AnalyticsView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI


struct AnalyticsView: View {
    @ObservedObject var vm: DashboardVM
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Analytics")
                            .font(.title.bold())
                        Text("Class Overview")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Total", value: "\(vm.students.count)", color: .orange)
                        StatCard(title: "Avg Attend", value: "\(Int(vm.overallAttendance() * 100))%", color: .blue)
                        StatCard(title: "Internship", value: "\(vm.students.filter { $0.stage == .internship }.count)", color: .green)
                    }
                    .padding(.horizontal)
                    
                    // Progress Sections
                    ForEach(StudentStage.allCases, id: \.self) { stage in
                        let count = vm.students.filter { $0.stage == stage }.count
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(stage.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text("\(count) students")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ProgressView(value: vm.percentage(for: stage))
                                .tint(stageColor(stage))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
    }
    
    func stageColor(_ stage: StudentStage) -> Color {
        switch stage {
        case .book1: return .orange
        case .book2: return .orange.opacity(0.7)
        case .internship: return .green
        }
    }
}
