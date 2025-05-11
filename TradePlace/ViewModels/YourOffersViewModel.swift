//
//  YourOffersView.swift
//  TradePlace
//
//  Created by Jan Huecking on 11/5/2025.
//
import Foundation
import SwiftUI

import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
class YourOffersViewModel : ObservableObject {
   
    @Published var items : [TradeOffer] = []
    @Published var isError = false;
    @Published var navigateToItemChangeView = false
    @Published var item : TradeItem = TradeItem(id: UUID(),
                                                images: [],
                                                title: "Test Item",
                                                description: "A description",
                                                estimatedPrice: 99.99,
                                                preferences: "Anything",
                                                isPostedOnMarketplace: true)
    
    let user = Auth.auth().currentUser!;

    init() {
        Task {
            await fetchItems();
        }
    }
    
    func fetchItems() async {
        let db = Firestore.firestore()
        do {
            let itemsForUser = try await db.collection("Users").document(user.uid).collection("TradeItems").getDocuments()
            var items : [TradeItem] = []
            for document in itemsForUser.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "";
                let description = data["description"] as? String ?? "";
                let preferences = data["preferences"] as? String ?? "";
                let estimatedPrice = data["estimatedPrice"] as? Double ?? 0.0
                let isPostedOnMarketplace = data["isPostedOnMarketplace"] as? Bool ?? false
                let tradeItem = TradeItem(id: UUID(uuidString: document.documentID)!, images: [], title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace)
                items.insert(tradeItem, at: 0)
            }
            self.items = items;
        } catch {
            isError = true;
        }
    }
}
