//
//  SignInView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import SwiftUI
struct RootView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                RoleRouterView(user: User(email: "", password: "", role: .facilitator))
            } else {
                SignInView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

struct SignInView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?
    @State private var showPassword = false
    @FocusState private var focused: Field?
    
    @State private var isShowingSignUpSheet = false
    
    enum Field { case email, password }
    
    let authService = AuthService()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 32))
                            .foregroundColor(.orange)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Sign in to your account")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 60)
                
                VStack(spacing: 20) {
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
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PASSWORD")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .kerning(1)
                        
                        HStack {
                            if showPassword {
                                TextField("Enter password", text: $password)
                            } else {
                                SecureField("Enter password", text: $password)
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
                        .submitLabel(.go)
                        .onSubmit {
                            signIn()
                        }
                    }
                    
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
                
                VStack(spacing: 20) {
                    Button {
                        signIn()
                    } label: {
                        HStack {
                            Text("Sign In")
                                .font(.body.weight(.semibold))
                            
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.orange, Color.orange.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
                    }
                    
                    Button {
                        isShowingSignUpSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Sign Up")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingSignUpSheet) {
            SignUpView(isCreating: $isShowingSignUpSheet)
                .presentationDetents([.medium])
        }
    }
    
    private func signIn() {
        error = nil
        focused = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please enter both email and password"
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter a valid email address"
            return
        }
        
        Task {
            do {
                let credentials = User(email: email, password: password)
                let response = try await authService.signIn(user: credentials)
                
                print("User Successfully Signed In: \(response.email) as \(response.role.capitalizedName)")
                
                await MainActor.run {
                    self.isAuthenticated = true
                }
                
            } catch {
                await MainActor.run {
                    self.error = "Invalid email or password"
                }
                print("Sign In Failed: ", error.localizedDescription)
            }
        }
    }
}

struct CleanTextFieldStyle: TextFieldStyle {
    let icon: String
    let isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundColor(isFocused ? .orange : .secondary)
                .frame(width: 20)
            
            configuration
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? .orange : Color(.systemGray5), lineWidth: isFocused ? 2 : 1)
                .background(Color(.systemBackground).cornerRadius(14))
                .shadow(color: isFocused ? .orange.opacity(0.1) : .clear, radius: 8, y: 2)
        )
    }
}

#Preview {
    RootView()
}
