//
//  AuthManager.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private var db = Firestore.firestore()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    
    var isAnonymous: Bool {
        return userSession?.isAnonymous ?? true
    }
    
    init() {
        self.userSession = Auth.auth().currentUser
        updateUserInfo()
        // აპლიკაციის ჩართვისას
        if userSession != nil {
            CartManager.shared.setupListeners()
            AddressManager.shared.fetchAddresses()
        }
    }
    
    func updateUserInfo() {
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                self.userEmail = "სტუმარი"
                self.userName = "სტუმარი"
            } else {
                self.userEmail = user.email ?? ""
                self.userName = user.displayName ?? "მომხმარებელი"
                
                CartManager.shared.setupListeners()
                AddressManager.shared.fetchAddresses()
            }
        } else {
            self.userEmail = ""
            self.userName = ""
        }
    }
    
    func login(withEmail email: String, password: String) {
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.userSession = result?.user
                self.updateUserInfo()
                // ლოგინის მერე ლისენერების ჩართვა
                CartManager.shared.setupListeners()
                AddressManager.shared.fetchAddresses()
                self.errorMessage = nil
            }
        }
    }
    
    func register(withEmail email: String, password: String, fullName: String) {
        self.isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let user = result?.user else { return }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            
            changeRequest.commitChanges { error in
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "email": email,
                    "fullName": fullName,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                self.db.collection("users").document(user.uid).setData(userData) { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.userName = fullName
                        self.userSession = Auth.auth().currentUser
                        self.updateUserInfo()
                        // რეგისტრაციის მერე ლისენერების ჩართვა
                        CartManager.shared.setupListeners()
                        AddressManager.shared.fetchAddresses()
                        self.errorMessage = nil
                    }
                }
            }
        }
    }
    
    func signInAnonymously() {
        self.isLoading = true
        Auth.auth().signInAnonymously { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.userSession = result?.user
                self.updateUserInfo()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.updateUserInfo()
                // მონაცემების გასუფთავება
                CartManager.shared.items = []
                AddressManager.shared.addresses = []
            }
        } catch {
            print("DEBUG: Error signing out - \(error.localizedDescription)")
        }
    }
    
    func updateUserEmail(newEmail: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let user = Auth.auth().currentUser, let currentEmail = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
