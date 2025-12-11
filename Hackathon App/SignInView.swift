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
    
    let authService: AuthService = AuthService()
    
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
            
            if let error = signInError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button("Sign In") {
                    signInError = nil
                    Task {
                        do {
                            let credentials = User(email: email, password: password)
                            
                            let response = try await authService.signIn(user: credentials)
                            
                            print("User Successfully Signed In: \(response.email)")
                            
                            isAuthenticated = true
                            
                        } catch {
                            print("Sign In Failed: ", error)
                            signInError = "Sign In Failed: Invalid email or password."
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .padding(.top, 50)
    }
}

#Preview {
    SignInView(isAuthenticated: .constant(false))
}
