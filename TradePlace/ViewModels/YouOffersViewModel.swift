//
//  YouOffersViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class YourOffersViewModel : ObservableObject {
    @Published var items : [TradeOffer] = []
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser!

    func fetchItems() async {
        items = [];
        do {
            let docs = try await db.collection("Users").document(Utils.uuid(from: currentUser.uid).uuidString).collection("TradeItem").getDocuments();
            for doc in docs.documents {
                let tradeOffer = await TradeOffer.fetchTradeOffer(doc.reference)
                if let tradeOffer = tradeOffer {
                    items.append(tradeOffer)
                }
            }
        } catch {
            return;
        }
    }
    
    func declineOffer(_ offer : TradeOffer) async {
        
    }
    
    func acceptOffer(_ offer : TradeOffer) async {
        
    }
}
