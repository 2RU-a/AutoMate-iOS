//
//  Service.swift
//  AutoMate
//
//  Created by oto rurua on 11.01.26.
//

//(Firebase managers, API services)

import Foundation

protocol AuthServiceProtocol {
    func register(email: String, password: String) async throws -> String
    func login(email: String, password: String) async throws
    func logout() throws
    var currentUserID: String? { get }
}

enum AuthError: LocalizedError {
    case emailAlreadyInUse
    case weakPassword
    case invalidCredentials
    case unknown

    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Email already in use"
        case .weakPassword:
            return "Password is too weak"
        case .invalidCredentials:
            return "Invalid email or password"
        case .unknown:
            return "Something went wrong"
        }
    }
}
