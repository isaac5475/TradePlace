//
//  ItemChangeViewModel.swift
//  TradePlace
//
//  Created by Jan Huecking on 6/5/2025.
//


import Foundation

import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ItemChangeViewModel : ObservableObject {
    
    @Published var isSubmitting = false;
    @Published var couldntSubmit : Bool? = nil;
    @Published var shouldNavigateToYourItems = false;
    
    let user = Auth.auth().currentUser!;
    
    func handleSubmit(toSubmit item : TradeItem) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(Utils.uuid(from: user.uid).uuidString).collection("TradeItems").document(item.id.uuidString);
        try await docRef.updateData([
            "title": item.title,
            "description": item.description,
            "estimatedPrice": item.estimatedPrice,
            "isPostedOnMarketplace": item.isPostedOnMarketplace,
            "preferences": item.preferences,
        ])
    }
    func deleteHandler(_ item : TradeItem) async throws {
        // Delete images for item from Firebase Storage.
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let itemFolderRef = storageRef.child("\(item.id.uuidString)");
        let imagesToDelete = try await itemFolderRef.listAll()
        for image in imagesToDelete.items {
            do {
                try await image.delete()
            }
            catch {
                print("error: deleting from storage")
            }
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(Utils.uuid(from: user.uid).uuidString).collection("TradeItems").document(item.id.uuidString);
        try await docRef.delete()
    }
}
