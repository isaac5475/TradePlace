//
//  YourItemsViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation

import Firebase
import FirebaseFirestore

@MainActor
class YourItemsViewModel : ObservableObject {
   
    @Published var items : [TradeItem] = []
    @Published var isError = false;
    
    private var user : AppUser;
    
    init(user usr : AppUser) {
        self.user = usr;
        
        Task {
            await fetchItems();
        }
    }
    
    private func fetchItems() async {
        let db = Firestore.firestore()
        do {
            let itemsForUser = try await db.collection("TradeItem").document(user.uid.uuidString).collection("TradeItems").getDocuments()
            print("fetched:", itemsForUser.documents.count)
            var items : [TradeItem] = []
            for document in itemsForUser.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "";
                let description = data["description"] as? String ?? "";
                let preferences = data["preferences"] as? String ?? "";
                let estimatedPrice = data["estimatedPrice"] as? Double ?? 0.0
                let isPostedOnMarketplace = data["isPostedOnMarketplace"] as? Bool ?? false
                let tradeItem = TradeItem(images: [], title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace)
                items.insert(tradeItem, at: 0)
            }
            self.items = items;
        } catch {
            isError = true;
        }
    }
}
