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
    @Published var addresses = [UserAddress]()
    private var db = Firestore.firestore()
    
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        fetchAddresses()
    }
    
    func fetchAddresses() {
        guard let uid = userId else { return }
        
        db.collection("users").document(uid).collection("addresses")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                self.addresses = documents.compactMap { try? $0.data(as: UserAddress.self) }
            }
    }
    
    func addAddress(_ address: UserAddress) {
        guard let uid = userId else { return }
        try? db.collection("users").document(uid).collection("addresses").addDocument(from: address)
    }
    
    func deleteAddress(at indexSet: IndexSet) {
        guard let uid = userId else { return }
        indexSet.forEach { index in
            let addressId = addresses[index].id ?? ""
            db.collection("users").document(uid).collection("addresses").document(addressId).delete()
        }
    }
}
