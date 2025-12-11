//
//  SignInView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


import SwiftUI



struct SignInView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signInError: String? = nil
    @State private var loggedInRole: Role? = nil
    
    let authService: AuthService = AuthService()
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .background(Color(.systemGray6))
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .background(Color(.systemGray6))
            
            if let role = loggedInRole {
                Text("Signed in as: \(role.capitalizedName)")
                    .font(.headline)
                    .foregroundColor(.blue)
            } else if let error = signInError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button("Sign In") {
                    signInError = nil
                    loggedInRole = nil
                    
                    guard isFormValid else {
                        signInError = "Please enter both email and password."
                        return
                    }
                    
                    Task {
                        do {
                            let credentials = User(email: email, password: password)
                            
                            // 1. Sign In is performed, and the user's role is automatically fetched by the service.
                            let response = try await authService.signIn(user: credentials)
                            
                            print("User Successfully Signed In: \(response.email) as \(response.role.capitalizedName)")
                            
                            // 2. Store the role and set authentication flag
                            loggedInRole = response.role
                            isAuthenticated = true
                            
                            // NOTE: At this point, you would typically use 'loggedInRole'
                            // to navigate to a role-specific dashboard (e.g., StudentDashboardView).
                            
                        } catch {
                            print("Sign In Failed: ", error.localizedDescription)
                            signInError = "Sign In Failed: Invalid email or password."
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFormValid ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!isFormValid)
            }
            .padding()
        }
        .padding(.top, 50)
    }
}

#Preview {
    SignInView(isAuthenticated: .constant(false))
}
