//
//  NetworkError.swift
//  Hackathon App
//
//  Created by Ian. T. Dzingira on 11/12/2025.
//


// NetworkService.swift
import Foundation
import Combine

// MARK: - Network Errors (Required by NetworkService)

enum NetworkError: Error, LocalizedError {
    // ... all cases defined previously ...
    case invalidURL
    case decodingFailed(detail: String)
    case requestFailed(status: Int, detail: String)
    case authenticationRequired
    case unknownError(detail: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .decodingFailed(let detail):
            return "Failed to decode response: \(detail)"
        case .requestFailed(let status, let detail):
            return "Request failed with status \(status): \(detail)"
        case .authenticationRequired:
            return "Authentication is required to perform this action."
        case .unknownError(let detail):
            return "An unknown network error occurred: \(detail)"
        }
    }
}

// MARK: - Network Service Protocol (Required by AuthViewModel)

protocol Networking {
    func post<T: Decodable, U: Encodable>(path: String, body: U, responseType: T.Type) async throws -> T
    func post<T: Decodable>(path: String, responseType: T.Type) async throws -> T
    func put<T: Decodable, U: Encodable>(path: String, body: U, responseType: T.Type) async throws -> T
}

// MARK: - Network Service Implementation

class NetworkService: Networking {
    
    static let shared = NetworkService()
    
    private let baseURL = "http://localhost:3001"
    
    private func createAuthenticatedRequest(path: String, httpMethod: String, body: Data? = nil) throws -> URLRequest {
        // ... implementation defined previously ...
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    func post<T: Decodable, U: Encodable>(path: String, body: U, responseType: T.Type) async throws -> T {
        // ... implementation defined previously ...
        let encoder = JSONEncoder()
        let requestBody = try encoder.encode(body)
        
        let request = try createAuthenticatedRequest(path: path, httpMethod: "POST", body: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError(detail: "Invalid response type.")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDetail = String(data: data, encoding: .utf8) ?? "No error details."
            throw NetworkError.requestFailed(status: httpResponse.statusCode, detail: errorDetail)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingFailed(detail: error.localizedDescription)
        }
    }
    
    func post<T: Decodable>(path: String, responseType: T.Type) async throws -> T {
        // ... implementation defined previously ...
        let request = try createAuthenticatedRequest(path: path, httpMethod: "POST")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError(detail: "Invalid response type.")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDetail = String(data: data, encoding: .utf8) ?? "No error details."
            throw NetworkError.requestFailed(status: httpResponse.statusCode, detail: errorDetail)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingFailed(detail: error.localizedDescription)
        }
    }
    
    func put<T: Decodable, U: Encodable>(path: String, body: U, responseType: T.Type) async throws -> T {
        // ... implementation defined previously ...
        let encoder = JSONEncoder()
        let requestBody = try encoder.encode(body)
        
        let request = try createAuthenticatedRequest(path: path, httpMethod: "PUT", body: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError(detail: "Invalid response type.")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDetail = String(data: data, encoding: .utf8) ?? "No error details."
            throw NetworkError.requestFailed(status: httpResponse.statusCode, detail: errorDetail)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingFailed(detail: error.localizedDescription)
        }
    }
}