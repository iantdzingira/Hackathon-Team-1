//
//  About.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 12/12/2025.
//
import SwiftUI

struct About_Page: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                
                
                VStack(alignment: .leading, spacing: 24) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is Matter Hub?")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Project Pulse is a unified project management platform designed specifically for MATTER's high-impact initiatives like the MCRI program. We transform how cross-functional teams communicate, track progress, and achieve goals moving beyond scattered email threads to a centralized, intelligent dashboard built for impact.")
                            .font(.body)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                    
                    // Mission Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Our Mission")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Empower every voice, align every team. Project Pulse brings structure to collaboration, giving every MATTER stakeholder—students, facilitators, managers, and donors—a clear view of progress, so together we can build futures faster.")
                            .font(.body)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                    
                    // Contact Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact us")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                Text("info@matter.org")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                Text("+1 201-500-2345")
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Legal Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Legal & Privacy")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                Text("Privacy Policy")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                Text("Terms of Service")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.shield.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                Text("Data Protection")
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Acknowledgements Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Acknowledgements")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("""
                        Project Pulse was inspired by MATTER's mission and built for everyone involved in their programs. We thank the students, facilitators, managers, and donors who shared their stories, and our team who brought this vision to life.
                        
                        Special thanks to the MCRI community for showing us what's possible when communication becomes clarity.
                        """)
                            .font(.body)
                            .lineSpacing(4)
                        
                        Text("Version 1.0.0")
                            .font(.headline)
                            .offset(x: 120, y: 0)
                            .fontWeight(.bold)
                        
                    }
                    
                    
                    .padding(.horizontal)
                    
                    // Footer spacing
                    Spacer()
                        .frame(height: 20)
                }
                .padding(.vertical)
            }
            .navigationTitle("About")
        }
    }
}

#Preview {
    About_Page()
}
