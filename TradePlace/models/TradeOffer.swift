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
    let id : UUID;
    let forItem: TradeItem;
    var offeredItems: [TradeItem];
    let fromUser: AppUser;
    let toUser: AppUser;
    var status: TradeOfferStatus;
    let createdAt: Date;
    var updatedAt: Date;
    
    init(id: UUID = UUID(), forItem: TradeItem, offeredItems: [TradeItem], fromUser: AppUser, toUser: AppUser, status: TradeOfferStatus, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.forItem = forItem
        self.offeredItems = offeredItems
        self.fromUser = fromUser
        self.toUser = toUser
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static func postTradeOffer(tradeOffer o : TradeOffer) async throws {
        let db = Firestore.firestore()
        let tradeOffersRef = db.collection("Users").document(o.toUser.id.uuidString).collection("TradeOffers");
        let fromUserRef = db.collection("Users").document(o.fromUser.id.uuidString);
        let forItemRef = db.collection("Users").document(o.toUser.id.uuidString).collection("TradeItems").document(o.forItem.id.uuidString);
        
        var offeredItemsRefs : [DocumentReference] = []
        let offeredItemPrefix = db.collection("Users").document(o.fromUser.id.uuidString).collection("TradeItems")
        
        for offeredItem in o.offeredItems {
            offeredItemsRefs.append(offeredItemPrefix.document(offeredItem.id.uuidString))
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
    
    static func fetchTradeOffer(_ offerRef: DocumentReference) async -> TradeOffer? {
        let db = Firestore.firestore()
        do {
            let data = try await offerRef.getDocument()
            guard let data = data.data() else { return nil; }
            guard let forItemRef = data["forItem"] as? DocumentReference else {return nil;}
            guard let fromUserRef = data["fromUser"] as? DocumentReference else {return nil;}
            guard let offeredItemsRefs = data["offeredItems"] as? [DocumentReference] else {return nil;}
            guard let status = data["status"] as? String else {return nil;}
            guard let updatedAt = data["updatedAt"] as? Timestamp else {return nil;}
            guard let createdAt = data["createdAt"] as? Timestamp else {return nil;}
            
            var offeredItemsFetched : [TradeItem] = []
            for offeredItemRef in offeredItemsRefs {
                if let offeredItem = await TradeItem.fetchTradeItem(offeredItemRef) {
                    offeredItemsFetched.append(offeredItem)
                }
            }
            guard let forItem = await TradeItem.fetchTradeItem(forItemRef) else { return nil; }
            guard let fromUser = await AppUser.fetchUser(userRef: fromUserRef) else { return nil; }
            
            let statusEnum = switch status {
            case "CREATED":
                TradeOfferStatus.CREATED
            case "CANCELLED":
                TradeOfferStatus.CANCELLED
            case "ACCEPTED":
                TradeOfferStatus.ACCEPTED
            default:
                TradeOfferStatus.CANCELLED
            }
            
            let pathSplit = offerRef.path.split(separator: "/")
            guard pathSplit.count >= 4 else {return nil;}
            let userId = String(pathSplit[1])
            
            let db = Firestore.firestore()
            let toUserRef : DocumentReference;
            do {
                toUserRef = try await db.collection("Users").document(userId).getDocument().reference;
            } catch {
                return nil;
            }
            guard let toUser = await AppUser.fetchUser(userRef: toUserRef) else {return nil;}
            
            return TradeOffer(forItem: forItem, offeredItems: offeredItemsFetched, fromUser: fromUser, toUser: toUser, status: statusEnum, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue())
        } catch {
            return nil;
        }
    }
}

    enum TradeOfferStatus : String {
    case CREATED, CANCELLED, ACCEPTED;
}


//let item1 = marketplaceItems.first!
//let item2 = marketplaceItems[1];
//let item3 = marketplaceItems[2];
//
//let user1 = AppUser(email: "user1@test.com", displayName: "bob")
//let user2 = AppUser(email: "user2@test.com", displayName: "alice")
//    let sampleOffers : [TradeOffer] = [
////    TradeOffer(forItem: item1, offeredItems: [item2], fromUser: user1, toUser: user2, status: .CREATED, createdAt: Date(), updatedAt: Date()),
////    TradeOffer(forItem: item2, offeredItems: [item1], fromUser: user2, toUser: user1, status: .CANCELLED, createdAt: Date(), updatedAt: Date())
//]
