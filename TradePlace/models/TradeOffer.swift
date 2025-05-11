//
//  TradeOffer.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TradeOffer: Identifiable {
    let id: UUID
    let forItem: TradeItem
    var offeredItems: [TradeItem]
    let fromUser: AppUser
    let toUser: AppUser
    var status: TradeOfferStatus
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        forItem: TradeItem,
        offeredItems: [TradeItem],
        fromUser: AppUser,
        toUser: AppUser,
        status: TradeOfferStatus,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.forItem = forItem
        self.offeredItems = offeredItems
        self.fromUser = fromUser
        self.toUser = toUser
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    static func postTradeOffer(tradeOffer o: TradeOffer) async throws {
        let db = Firestore.firestore()
        let tradeOffersRef = db.collection("Users")
            .document(o.toUser.id.uuidString)
            .collection("TradeOffers")

        let fromUserRef = db.collection("Users").document(o.fromUser.id.uuidString)
        let forItemRef = db.collection("Users")
            .document(o.toUser.id.uuidString)
            .collection("TradeItems")
            .document(o.forItem.id.uuidString)

        var offeredItemsRefs: [DocumentReference] = []
        let offeredItemPrefix = db.collection("Users")
            .document(o.fromUser.id.uuidString)
            .collection("TradeItems")

        for offeredItem in o.offeredItems {
            offeredItemsRefs.append(offeredItemPrefix.document(offeredItem.id.uuidString))
        }

        try await tradeOffersRef.document(o.id.uuidString).setData([
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
            let snapshot = try await offerRef.getDocument()
            guard let data = snapshot.data() else { return nil }

            guard
                let forItemRef = data["forItem"] as? DocumentReference,
                let fromUserRef = data["fromUser"] as? DocumentReference,
                let offeredItemsRefs = data["offeredItems"] as? [DocumentReference],
                let status = data["status"] as? String,
                let updatedAt = data["updatedAt"] as? Timestamp,
                let createdAt = data["createdAt"] as? Timestamp
            else {
                return nil
            }

            let forItem = await TradeItem.fetchTradeItem(forItemRef)
            let fromUser = await AppUser.fetchUser(userRef: fromUserRef)
            let toUserID = offerRef.path.split(separator: "/")[1]
            let toUserRef = db.collection("Users").document(String(toUserID))
            let toUser = await AppUser.fetchUser(userRef: toUserRef)

            guard let forItem = forItem, let fromUser = fromUser, let toUser = toUser else { return nil }

            var offeredItemsFetched: [TradeItem] = []
            for itemRef in offeredItemsRefs {
                if let item = await TradeItem.fetchTradeItem(itemRef) {
                    offeredItemsFetched.append(item)
                }
            }

            let statusEnum = TradeOfferStatus(rawValue: status) ?? .CANCELLED
            let uuid = UUID(uuidString: offerRef.documentID) ?? UUID()

            return TradeOffer(
                id: uuid,
                forItem: forItem,
                offeredItems: offeredItemsFetched,
                fromUser: fromUser,
                toUser: toUser,
                status: statusEnum,
                createdAt: createdAt.dateValue(),
                updatedAt: updatedAt.dateValue()
            )

        } catch {
            print("Error fetching trade offer: \(error)")
            return nil
        }
    }

    // MARK: - Accept & Reject Handlers
    func accept() async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("Users")
            .document(toUser.id.uuidString)
            .collection("TradeOffers")
            .document(id.uuidString)

        try await docRef.updateData([
            "status": TradeOfferStatus.ACCEPTED.rawValue,
            "updatedAt": Timestamp(date: Date())
        ])
    }

    func reject() async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("Users")
            .document(toUser.id.uuidString)
            .collection("TradeOffers")
            .document(id.uuidString)

        try await docRef.updateData([
            "status": TradeOfferStatus.CANCELLED.rawValue,
            "updatedAt": Timestamp(date: Date())
        ])
    }
}

enum TradeOfferStatus: String {
    case CREATED
    case CANCELLED
    case ACCEPTED
}
