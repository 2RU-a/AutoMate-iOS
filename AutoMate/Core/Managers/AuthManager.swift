//
//  AuthManager.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import Foundation
import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    
    var isAnonymous: Bool {
            return userSession?.isAnonymous ?? true
        }
    
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.userSession = result?.user
            self.errorMessage = nil
        }
    }
    
    func register(withEmail email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Registration error - \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }
            
            // მომხმარებლის სახელის შენახვა პროფილში
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            
            changeRequest?.commitChanges { error in
                if let error = error {
                    print("DEBUG: Error saving display name - \(error.localizedDescription)")
                }
                
                // სესიის განახლება სახელის შენახვის შემდეგ
                DispatchQueue.main.async {
                    self.userSession = Auth.auth().currentUser
                    self.errorMessage = nil
                }
            }
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("DEBUG: Anonymous Sign-In Error: \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: Error signing out - \(error.localizedDescription)")
        }
    }
}
