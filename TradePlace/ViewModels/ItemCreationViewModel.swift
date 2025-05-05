//
//  ItemCreationViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation

import Firebase
import FirebaseFirestore

class ItemCreationViewModel : ObservableObject {
    
    @Published var isSubmitting = false;
    @Published var couldntSubmit : Bool? = nil;
    
    func handleSubmit(toSubmit item : TradeItem, ownedBy user : AppUser) async throws {
        
        let db = Firestore.firestore()
        let tradeItemsForUser = db.collection("TradeItem").document(user.uid.uuidString).collection("TradeItems");
        try await tradeItemsForUser.addDocument(data: [
            "title": item.title,
            "description": item.description,
            "estimatedPrice": item.estimatedPrice,
            "isPostedOnMarketplace": item.isPostedOnMarketplace,
            "preferences": item.preferences,
        ])
    }
}
