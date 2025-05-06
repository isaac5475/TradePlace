//
//  ItemCreationViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseAuth

class ItemCreationViewModel : ObservableObject {
    
    @Published var isSubmitting = false;
    @Published var couldntSubmit : Bool? = nil;
    @Published var shouldNavigateToYourItems = false;
    
    let user = Auth.auth().currentUser!;
    
    func handleSubmit(toSubmit item : TradeItem) async throws {
        let db = Firestore.firestore()
        let tradeItemsForUser = db.collection("Users").document(user.uid).collection("TradeItems");
        try await tradeItemsForUser.document(item.id.uuidString).setData([
            "title": item.title,
            "description": item.description,
            "estimatedPrice": item.estimatedPrice,
            "isPostedOnMarketplace": item.isPostedOnMarketplace,
            "preferences": item.preferences,
        ])
    }
}
