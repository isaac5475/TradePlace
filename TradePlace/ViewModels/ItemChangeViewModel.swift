//
//  ItemChangeViewModel.swift
//  TradePlace
//
//  Created by Jan Huecking on 6/5/2025.
//


import Foundation

import Firebase
import FirebaseFirestore
import FirebaseAuth

class ItemChangeViewModel : ObservableObject {
    
    @Published var isSubmitting = false;
    @Published var couldntSubmit : Bool? = nil;
    @Published var shouldNavigateToYourItems = false;
    
    let user = Auth.auth().currentUser!;
    
    func handleSubmit(toSubmit item : TradeItem) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(user.uid).collection("TradeItems").document(item.id.uuidString);
        try await docRef.updateData([
            "title": item.title,
            "description": item.description,
            "estimatedPrice": item.estimatedPrice,
            "isPostedOnMarketplace": item.isPostedOnMarketplace,
            "preferences": item.preferences,
        ])
    }
}
