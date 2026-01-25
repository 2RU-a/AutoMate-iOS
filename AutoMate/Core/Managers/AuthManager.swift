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
import GoogleSignIn
import FirebaseCore

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
    
    // MARK: - Google Sign In
    func signInWithGoogle(completion: @escaping (Bool, String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(false, "Internal Error")
            return
        }
        
        self.isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    completion(false, "Google Identity Error")
                }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        self?.userSession = authResult?.user
                        self?.updateUserInfo()
                        completion(true, nil)
                    }
                }
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
                AddressManager.shared.fetchAddresses()
                
                // რომ ფავორიტებიც წაიშალოს
                FavoritesManager.shared.clearAll()
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

extension AuthManager {
    // 1. SMS კოდის გაგზავნა
    func sendVerificationCode(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        self.errorMessage = nil
        print("DEBUG: Sending code to \(phoneNumber)...")
        
        // მნიშვნელოვანია სიმულატორზე ტესტირებისას
        // Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("DEBUG: Phone Auth Error: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let verificationID = verificationID else {
                    print("DEBUG: Verification ID is nil")
                    completion(false, "Verification ID not found")
                    return
                }
                
                print("DEBUG: Verification ID received and saved: \(verificationID)")
                // ვინახავთ ID-ს, რომელიც კოდის დადასტურებისას დაგვჭირდება
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(true, nil)
            }
        }
    }

    // 2. კოდის შემოწმება და შესვლა
    func verifyCode(_ code: String, completion: @escaping (Bool, String?) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(false, "Internal Error: No verification ID found")
            return
        }
        
        self.isLoading = true
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self?.userSession = authResult?.user
                    self?.updateUserInfo()
                    completion(true, nil)
                }
            }
        }
    }
}
