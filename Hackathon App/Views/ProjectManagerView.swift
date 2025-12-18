//
//  ProjectManagerView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 6))
                .opacity(0.3)
                .foregroundColor(color.opacity(0.3))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)

            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
        }
        .frame(width: 50, height: 50)
    }
}

struct FilterButton: View {
    let label: String
    @Binding var selected: String
    
    var isSelected: Bool { label == selected }
    
    var body: some View {
        Button(action: {
            selected = label
        }) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color.pink.opacity(0.8) : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(18)
        }
    }
}

// MARK: - 3. NAVIGATION TARGETS

struct AddUserView: View {
    let projectName: String
    @State private var userName: String = ""
    @State private var userRole: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Add User to \(projectName)")) {
                TextField("User/Student Name", text: $userName)
                TextField("Role (e.g., Developer, QA, Intern)", text: $userRole)
                Button("Add to Team") {
                  print("Adding \(userName) as \(userRole) to \(projectName)")
                }
            }
        }
        .navigationTitle("Add Team Member")
    }
}

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Status: \(project.status.rawValue)")
                            .foregroundColor(project.status.color)
                    }
                    Spacer()
                    ProgressRingView(progress: project.progress, color: project.status.color)
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom)
                
                Divider()
                Text("Task and Milestone Breakdown")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(0..<4) { i in
                        HStack {
                            Image(systemName: i < Int(project.progress * 4) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(i < Int(project.progress * 4) ? .green : .gray)
                            Text("Milestone \(i + 1): Implementation Phase \(i + 1)")
                        }
                    }
                }
                .padding(.leading)
                
                Divider()

                Text("Team Information")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Team Size: \(project.teamSize) Members")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 5) {
                        ForEach(0..<project.teamSize, id: \.self) { _ in
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 5)
                
            }
            .padding()
        }
        .navigationTitle("Project Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - 4. CARD COMPONENT

struct ProjectCardView: View {
    let project: Project
    let totalTasks: Int
    
    var ringColor: Color { project.status.color }
    
    var body: some View {
        HStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(project.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Digital Product Design")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: -10) {
                    ForEach(0..<min(project.teamSize, 4), id: \.self) { index in
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(x: CGFloat(index) * -6)
                    }
                }
                .padding(.leading, 10)
                HStack {
                    Image(systemName: "calendar").font(.caption2)
                    Text("Jan 13, 2024").font(.caption2).foregroundColor(.gray)
                    Spacer()
                    Text("\(totalTasks) Tasks").font(.caption2).foregroundColor(.gray)
                }
                .padding(.top, 5)
            }
            
            Spacer()
            VStack(alignment: .trailing) {
                ProgressRingView(progress: project.progress, color: ringColor)
                
                Spacer()
                NavigationLink(destination: AddUserView(projectName: project.name)) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}


// MARK: - 5. MAIN PROJECTS VIEW (The center screen of the design)

struct ProjectsView: View {
    
    @State private var projects = sampleProjects
    @State private var selectedFilter: String = "All"
    private let tasks = [26, 12, 55, 30, 15, 8]
    var filteredProjects: [Project] {
        if selectedFilter == "All" {
            return projects
        }
        if selectedFilter == "Completed" {
            return projects.filter { $0.progress >= 1.0 }
        }
        
        let statusFilter: ProjectStatus?
        switch selectedFilter {
        case "Ongoing":
            statusFilter = .yellow
        case "Late":
            statusFilter = .red
        default:
            statusFilter = nil
        }
        return projects.filter { $0.status == statusFilter && $0.progress < 1.0 }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Projects")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                
                    HStack {
                        FilterButton(label: "All", selected: $selectedFilter)
                        FilterButton(label: "Ongoing", selected: $selectedFilter)
                        FilterButton(label: "Completed", selected: $selectedFilter)
                        FilterButton(label: "Late", selected: $selectedFilter)
                        Spacer()
                    }
                    .padding(.horizontal)

                    LazyVStack(spacing: 15) {
                        ForEach(filteredProjects.indices, id: \.self) { index in
                            
                            NavigationLink(destination: ProjectDetailView(project: filteredProjects[index])) {
                                ProjectCardView(
                                    project: filteredProjects[index],
                                    totalTasks: tasks[index % tasks.count]
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ProjectsView()
}
