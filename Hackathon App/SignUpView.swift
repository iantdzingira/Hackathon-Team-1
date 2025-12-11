//
//  SignUpView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


import SwiftUI

struct SignUpView: View {
    @Binding var isCreating: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "Student"
    @State private var error: String?
    @State private var showingRoleSheet = false
    
    let roles = ["Student", "Donor", "Facilitator", "Project Manager", "Intern", "Hiring Company", "Manager"]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "person.badge.plus")
                                .font(.title2)
                                .foregroundColor(.orange)
                        )
                    
                    Text("Create Account")
                        .font(.title2.bold())
                    
                    Text("Fill in your details")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Form
                VStack(spacing: 16) {
                    // Email
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email").font(.caption).foregroundColor(.secondary)
                        TextField("Enter Email", text: $email)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password").font(.caption).foregroundColor(.secondary)
                        SecureField("Enter password", text: $password)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .textInputAutocapitalization(.never)
                    }
                    
                    // Role Selection Button
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Role").font(.caption).foregroundColor(.secondary)
                        Button {
                            showingRoleSheet = true
                        } label: {
                            HStack {
                                Text(selectedRole)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                    
                    if let error = error {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Buttons
                VStack(spacing: 12) {
                    Button {
                        signUp()
                    } label: {
                        Text("Sign Up")
                            .font(.body.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        isCreating = false
                    } label: {
                        Text("Back to Sign In")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingRoleSheet) {
            RoleSelectionSheet(selectedRole: $selectedRole, roles: roles)
        }
    }
    
    private func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill all fields"
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter a valid email"
            return
        }
        
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters"
            return
        }
        
        error = nil
        
        Task {
            do {
                guard let userRole = Role(rawValue: selectedRole.lowercased()) else {
                    error = "Invalid role selected"
                    return
                }
                
                let newUser = User(email: email, password: password, role: userRole)
                let response = try await AuthService().signUp(user: newUser)
                print("Signed up: \(response.email) as \(response.role)")
                isCreating = false
            } catch {
                self.error = "Sign up failed. Please try again."
            }
        }
    }
}

// Role Selection Sheet
struct RoleSelectionSheet: View {
    @Binding var selectedRole: String
    let roles: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(roles, id: \.self) { role in
                    Button {
                        selectedRole = role
                        dismiss()
                    } label: {
                        HStack {
                            Text(role)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedRole == role {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Select Role")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

#Preview {
    SignUpView(isCreating: .constant(true))
}
