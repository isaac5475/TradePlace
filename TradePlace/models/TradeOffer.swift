//
//  TradeOffer.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TradeOffer : Identifiable {
    let id = UUID();
    let forItem: TradeItem;
    var offeredItems: [TradeItem];
    let fromUser: AppUser;
    let toUser: AppUser;
    var status: TradeOfferStatus;
    let createdAt: Date;
    var updatedAt: Date;
    
    static func saveTradeOffer(tradeOffer o : TradeOffer) async throws {
        let db = Firestore.firestore()
        let tradeOffersRef = db.collection("Users").document(o.toUser.uid.uuidString).collection("TradeOffers");
        let fromUserRef = db.collection("Users").document(o.fromUser.uid.uuidString);
        let forItemRef = db.collection("Users").document(o.toUser.uid.uuidString).collection("TradeItems").document(o.forItem.id.uuidString);
        
        var offeredItemsRefs : [DocumentReference] = []
        let offeredItemPrefix = db.collection("Users").document(o.fromUser.uid.uuidString).collection("TradeItems")
        
        for offeredItem in o.offeredItems {
            offeredItemsRefs.append(offeredItemPrefix.document(offeredItem.uid.uuidString))
        }

        try await tradeOffersRef.addDocument(data: [
            "fromUser": fromUserRef,
            "forItem": forItemRef,
            "status": o.status.rawValue,
            "offeredItems": offeredItemsRefs,
            "createdAt": Timestamp(date: o.createdAt),
            "updatedAt": Timestamp(date: o.updatedAt)
        ])
    }
    
}

enum TradeOfferStatus : String {
    case CREATED, CANCELLED, ACCEPTED;
}

let item1 = marketplaceItems.first!
let item2 = marketplaceItems[1];
let item3 = marketplaceItems[2];

let user1 = AppUser(email: "user1@test.com", displayName: "bob")
let user2 = AppUser(email: "user2@test.com", displayName: "alice")
let sampleOffers = [
    TradeOffer(forItem: item1, offeredItems: [item2], fromUser: user1, toUser: user2, status: .CREATED, createdAt: Date(), updatedAt: Date()),
    TradeOffer(forItem: item2, offeredItems: [item1], fromUser: user2, toUser: user1, status: .CANCELLED, createdAt: Date(), updatedAt: Date())
]


