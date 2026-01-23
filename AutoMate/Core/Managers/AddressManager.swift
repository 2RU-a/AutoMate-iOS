//
//  AddressManager.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class AddressManager: ObservableObject {
    // 1. დაამატე ეს ხაზი შეცდომის გასასწორებლად
    static let shared = AddressManager()
    
    @Published var addresses = [UserAddress]()
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration? // ლისენერის სამართავად
    
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    // 2. private init, რომ ყველგან ერთი და იგივე shared ეგზემპლარი გამოვიყენოთ
    private init() {
        fetchAddresses()
    }
    
    func fetchAddresses() {
        guard let uid = userId else {
            self.addresses = []
            return
        }
        
        // ძველი ლისენერის მოცილება (რომ მონაცემები არ გაორდეს)
        listener?.remove()
        
        listener = db.collection("users").document(uid).collection("addresses")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("DEBUG: No addresses found")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.addresses = documents.compactMap { try? $0.data(as: UserAddress.self) }
                }
            }
    }
    
    func addAddress(_ address: UserAddress) {
        guard let uid = userId else { return }
        do {
            try db.collection("users").document(uid).collection("addresses").addDocument(from: address)
        } catch {
            print("DEBUG: Error adding address: \(error.localizedDescription)")
        }
    }
    
    func deleteAddress(at indexSet: IndexSet) {
        guard let uid = userId else { return }
        indexSet.forEach { index in
            let addressId = addresses[index].id ?? ""
            db.collection("users").document(uid).collection("addresses").document(addressId).delete()
        }
    }
}
