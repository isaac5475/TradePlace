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
    let id : UUID
    var images : [Image];
    var title: String;
    var description: String;
    var estimatedPrice: Double;
    var preferences: String;
    var isPostedOnMarketplace: Bool;
    let belongsTo: AppUser;
    
    init(
        id: UUID = UUID(),
        images: [Image],
        title: String,
        description: String,
        estimatedPrice: Double,
        preferences: String,
        isPostedOnMarketplace: Bool,
        belongsTo: AppUser
    ) {
        self.id = id
        self.images = images
        self.title = title
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.preferences = preferences
        self.isPostedOnMarketplace = isPostedOnMarketplace
        self.belongsTo = belongsTo
    }
    
    static func parseTradeItem(tradeItemId id: UUID, _ data: [String: Any]) async -> TradeItem? {
        let title = data["title"] as? String ?? "";
        let description = data["description"] as? String ?? "";
        let preferences = data["preferences"] as? String ?? "";
        let estimatedPrice = data["estimatedPrice"] as? Double ?? 0.0
        let isPostedOnMarketplace = data["isPostedOnMarketplace"] as? Bool ?? false
    
        guard let belongsToRef = data["belongsTo"] as? DocumentReference else {
            return nil;
        }
        guard let belongsTo = await AppUser.fetchUser(userRef: belongsToRef) else { return nil; }
        
        return TradeItem(id: id, images: [] /* images loaded in the background after to avoid slow loading of page */ , title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace, belongsTo: belongsTo)
    }
    static func fetchTradeItem(_ docRef: DocumentReference) async -> TradeItem?{
        do {
            let data = try await docRef.getDocument()
            guard let data = data.data() else {return nil;}
            guard let documentId = docRef.path.split(separator: "/").last else {return nil;}    //  try to get the id of the trade item, which is stored in path
            let documentIdStr = String(documentId)
            return await TradeItem.parseTradeItem(tradeItemId: UUID(uuidString: documentIdStr)!, data)
        } catch {
            return nil;
        }
    }
}

//var marketplaceItems = [
//    TradeItem(
//        images: [], title: "Bicycle", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Guitar", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Camera", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Guitar2", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "PC", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: false),
//    TradeItem(
//        images: [], title: "Shoes", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true
//    )
//]
