//
//  TradeItem.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import SwiftUICore

struct TradeItem : Identifiable {
    let id : UUID
    var images : [Image];
    var title: String;
    var description: String;
    var estimatedPrice: Double;
    var preferences: String;
    var isPostedOnMarketplace: Bool;
    //let belongsTo: User;
    
    init(
        id: UUID = UUID(),
        images: [Image],
        title: String,
        description: String,
        estimatedPrice: Double,
        preferences: String,
        isPostedOnMarketplace: Bool
    ) {
        self.id = id
        self.images = images
        self.title = title
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.preferences = preferences
        self.isPostedOnMarketplace = isPostedOnMarketplace
    }
}

var marketplaceItems = [
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
