//
//  TradeOffer.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import FirebaseAuth

struct TradeOffer : Identifiable {
    let id = UUID();
    let forItem: TradeItem;
    var offeredItems: [TradeItem];
    let fromUser: AppUser;
    let toUser: AppUser;
    var status: TradeOfferStatus;
    let createdAt: Date;
    var updatedAt: Date;
}

enum TradeOfferStatus {
    case CREATED, CANCELLED, ACCEPTED;
}

struct AppUser {
    let id = UUID();
    let uid = UUID();
    let email: String?;
    let displayName: String?
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
