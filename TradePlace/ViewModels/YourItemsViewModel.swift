//
//  YourItemsViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation
import SwiftUI

import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@MainActor
class YourItemsViewModel : ObservableObject {
   
    @Published var items : [TradeItem] = []
    @Published var isError = false;
    @Published var navigateToItemChangeView = false
    
    let user = Auth.auth().currentUser!;

    init() {
        Task {
            await fetchItems();
        }
    }
    
    
    
    func fetchItems() async {
        let db = Firestore.firestore()
        do {
            let itemsForUser = try await db.collection("Users").document(Utils.uuid(from: user.uid).uuidString).collection("TradeItems").getDocuments()
            var items : [TradeItem] = []
            for document in itemsForUser.documents {
                let tradeItem = await TradeItem.fetchTradeItem(document.reference, fetchImages: true)
                if let tradeItem = tradeItem {
                    items.append(tradeItem)
                } else {
                    continue;
                }
            }
            self.items = items;
        } catch {
            isError = true;
        }
    }
}
