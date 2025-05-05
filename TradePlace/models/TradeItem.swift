//
//  TradeItem.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import SwiftUICore
import FirebaseFirestore

struct TradeItem : Identifiable {
    let id = UUID();
    let uid : UUID;
    let images : [Image];
    let title: String;
    let description: String;
    let estimatedPrice: Double;
    let preferences: String;
    var isPostedOnMarketplace: Bool;
    //let belongsTo: User;
    
    init(uid : UUID = UUID(), images: [Image], title: String, description: String, estimatedPrice: Double, preferences: String, isPostedOnMarketplace: Bool) {
        self.uid = uid;
        self.images = images
        self.title = title
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.preferences = preferences
        self.isPostedOnMarketplace = isPostedOnMarketplace
    }
    
    static func getTradeItemFromRef(itemRef ref : DocumentReference) -> TradeItem? {
        var result : TradeItem?;
        ref.getDocument() { itemSnapshot, err in
            if let itemData = itemSnapshot?.data() {
                guard let title = itemData["title"] as? String else {
                    return;
                }
                guard let description = itemData["description"] as? String else {
                    return;
                }
                guard let preferences = itemData["preferences"] as? String else {
                    return;
                }
                guard let isPostedOnMarketplace = itemData["isPostedOnMarketplace"] as? Bool else {
                    return;
                }
                guard let estimatedPrice = itemData["estimatedPrice"] as? Double else {
                    return;
                }
                result = TradeItem(uid: UUID(uuidString: ref.documentID)!, images: [], title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace)
            }
        }
        return result;
    }

}

let marketplaceItems = [
    TradeItem(
        images: [], title: "Bicycle", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
    TradeItem(
        images: [], title: "Guitar", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
    TradeItem(
        images: [], title: "Camera", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
    TradeItem(
        images: [], title: "Guitar2", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
    TradeItem(
        images: [], title: "PC", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: false),
    TradeItem(
        images: [], title: "Shoes", description: "hi",
        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true
    )
]
