//
//  AuthService.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import Foundation

struct AuthResponse: Codable {
    let message: String
    let email: String
}


class AuthService {
    private let baseURL = URL(string: "http://localhost:3001")!
    
    func signUp(user: User) async throws -> AuthResponse {
        let url = baseURL.appendingPathComponent("auth/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw NSError(domain: "AuthError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Sign up failed with status code: \(statusCode)"])
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func signIn(user: User) async throws -> AuthResponse {
        let url = baseURL.appendingPathComponent("auth/signin")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw NSError(domain: "AuthError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Sign in failed with status code: \(statusCode)"])
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
}
