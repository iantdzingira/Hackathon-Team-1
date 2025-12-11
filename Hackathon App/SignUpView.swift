//
//  SignUpView.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


import SwiftUI

struct SignUpView: View {
    @Binding var isCreating: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signupError: String? = nil
    
    let authService: AuthService = AuthService()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
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
            
            if let error = signupError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button("Sign Up") {
                    signupError = nil
                    Task {
                        do {
                            let newUser = User(email: email, password: password)
                            
                            let response = try await authService.signUp(user: newUser)
                            
                            print("User Successfully Signed Up: \(response.email)")
                            
                            isCreating.toggle()
                            
                        } catch {
                            print("Sign Up Failed: ", error)
                            signupError = "Sign Up Failed: Invalid credentials or email may already exist."
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.cyan)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Cancel") {
                    isCreating.toggle()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .padding(.top, 50)
    }
}



#Preview {
    SignUpView(isCreating: .constant(true))
}
