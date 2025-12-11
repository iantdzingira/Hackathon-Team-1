//
//  AuthService.swift
//  Hackathon
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//

import Foundation

struct APIErrorResponse: Codable {
    let error: String
}

struct AuthResponse: Codable {
    let message: String
    let email: String
    let role: Role
}

class AuthService {
    private let baseURL = URL(string: "http://localhost:3001")!
    
    private func handleAPIError(data: Data, response: URLResponse) throws -> Never {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        
        // 1. Try to decode a structured error response from the server body
        if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            throw NSError(domain: "AuthError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.error])
        }
        
        // 2. Fallback to a generic error if decoding failed
        throw NSError(domain: "AuthError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Authentication failed with status code: \(statusCode)"])
    }
    
    func signUp(user: User) async throws -> AuthResponse {
        guard user.role != nil else {
            throw NSError(domain: "ClientError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Role selection is required for sign up."])
        }
        
        let url = baseURL.appendingPathComponent("auth/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            try handleAPIError(data: data, response: response)
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
            // Use improved error handling for detailed feedback
            try handleAPIError(data: data, response: response)
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
}
