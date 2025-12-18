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
    @State private var showPassword = false
    @FocusState private var focused: Field?
    
    enum Field { case email, password }
    
    let roles = ["Student", "Donor", "Facilitator", "Project Manager", "Intern", "Hiring Company", "Manager"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // Header
                VStack(spacing: 16) {
                    
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 60)
                
                // Form
                VStack(spacing: 20) {
                    // Email field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("EMAIL")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .kerning(1)
                        
                        TextField("Enter Email", text: $email)
                            .textFieldStyle(CleanTextFieldStyle(
                                icon: "envelope",
                                isFocused: focused == .email
                            ))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focused, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focused = .password }
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PASSWORD")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .kerning(1)
                        
                        HStack {
                            if showPassword {
                                TextField("Create a password", text: $password)
                            } else {
                                SecureField("Create a password", text: $password)
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                        .textFieldStyle(CleanTextFieldStyle(
                            icon: "lock",
                            isFocused: focused == .password
                        ))
                        .textInputAutocapitalization(.never)
                        .focused($focused, equals: .password)
                        .submitLabel(.done)
                        
                        // Password strength indicator
                        if !password.isEmpty {
                            PasswordStrengthIndicator(password: password)
                        }
                    }
                    
                    // Role Selection
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ROLE")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .kerning(1)
                        
                        Button {
                            showingRoleSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.secondary)
                                    .font(.callout)
                                    .frame(width: 20)
                                
                                Text(selectedRole)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                                    .background(Color(.systemBackground).cornerRadius(14))
                            )
                        }
                    }
                    
                    // Error message
                    if let error = error {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 4)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 24)
                
                // Buttons
                VStack(spacing: 16) {
                    Button {
                        signUp()
                    } label: {
                        HStack {
                            Text("Create Account")
                                .font(.body.weight(.semibold))
                            
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.customOrange, Color.customOrange.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .customOrange.opacity(0.3), radius: 8, y: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingRoleSheet) {
            RoleSelectionSheet(selectedRole: $selectedRole, roles: roles)
        }
    }
    
    private func signUp() {
        error = nil
        focused = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill all fields"
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter a valid email address"
            return
        }
        
        guard password.count >= 6 else {
            error = "Password must be at least 6 characters"
            return
        }
        
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
                            Image(systemName: iconForRole(role))
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            
                            Text(role)
                                .foregroundColor(.primary)
                                .font(.body)
                            
                            Spacer()
                            
                            if selectedRole == role {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select Your Role")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func iconForRole(_ role: String) -> String {
        switch role {
        case "Student": return "person.fill"
        case "Donor": return "heart.fill"
        case "Facilitator": return "person.2.fill"
        case "Project Manager": return "briefcase.fill"
        case "Intern": return "graduationcap.fill"
        case "Hiring Company": return "building.2.fill"
        case "Manager": return "person.crop.circle.fill"
        default: return "person.fill"
        }
    }
}

struct PasswordStrengthIndicator: View {
    let password: String
    
    private var strength: (color: Color, text: String, width: CGFloat) {
        let length = password.count
        if length >= 8 && containsUppercase && containsNumber {
            return (.green, "Strong", 1.0)
        } else if length >= 6 {
            return (.orange, "Medium", 0.66)
        } else {
            return (.red, "Weak", 0.33)
        }
    }
    
    private var containsUppercase: Bool {
        password.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    private var containsNumber: Bool {
        password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Password strength: \(strength.text)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(strength.color)
                        .frame(width: geometry.size.width * strength.width, height: 4)
                        .animation(.easeInOut, value: password)
                }
            }
            .frame(height: 4)
            
            if password.count > 0 {
                HStack(spacing: 12) {
                    RequirementRow(text: "8+ characters", isMet: password.count >= 8)
                    RequirementRow(text: "Uppercase", isMet: containsUppercase)
                    RequirementRow(text: "Number", isMet: containsNumber)
                }
                .padding(.top, 4)
            }
        }
    }
}

struct RequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.caption2)
                .foregroundColor(isMet ? .green : .secondary)
            
            Text(text)
                .font(.caption2)
                .foregroundColor(isMet ? .secondary : .secondary.opacity(0.7))
        }
    }
}

#Preview {
    SignUpView(isCreating: .constant(true))
}
