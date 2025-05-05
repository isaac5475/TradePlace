//
//  YourOffersViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class YourOffersViewModel : ObservableObject {
    @Published var yourOffers : [TradeOffer] = []

    let user = Auth.auth().currentUser!;

    init() {
        Task {
            await fetchOffers();
        }
    }
    
    func fetchOffers() async {
        let db = Firestore.firestore()
        do {
            let offersForUser = try await db.collection("Users").document(user.uid).collection("TradeOffers").getDocuments()
            var offers : [TradeOffer] = []
            for document in offersForUser.documents {
                if let offer = getTradeOffer(document) {
                    offers.append(offer)
                }
            }
            print("offers fetched:", offers.count)
            print(offers)
            self.yourOffers = offers;
        } catch {
            print("\(error)")
        }
    }
    
    private func getTradeOffer(_ document : QueryDocumentSnapshot) -> TradeOffer? {
        let data = document.data();
        guard let fromUserRef = data["fromUser"] as? DocumentReference else {
            return nil;
        }
        
        guard let fromUser = getUserFromRef(userRef: fromUserRef) else {
            return nil;
        }
        guard let forItemRef = data["forItem"] as? DocumentReference else {
            return nil;
        }
        guard let forItem = getTradeItemFromRef(itemRef: forItemRef) else {
            return nil;
        }
        
        guard let offeredItemsRefs = data["offererdItems"] as? [DocumentReference] else {
            return nil;
        }
        var offeredItems : [TradeItem] = [];
        for offeredItemsRef in offeredItemsRefs {
            if let offeredTradeItem = getTradeItemFromRef(itemRef: offeredItemsRef) {
                offeredItems.append(offeredTradeItem);
            }
        }
        
        guard let statusString = data["status"] as? String else {
            return nil;
        }
        let status = switch statusString {
        case "CREATED":
            TradeOfferStatus.CREATED
        case "ACCEPTED":
            TradeOfferStatus.ACCEPTED
        case "CANCELED":
            TradeOfferStatus.CANCELLED
        default:
            TradeOfferStatus.CANCELLED
        }
        
        guard let createdAtTimestamp = data["createdAt"] as? Timestamp else {
            return nil;
        }
        guard let updatedAtTimestamp = data["updatedAt"] as? Timestamp else {
            return nil;
        }
        return TradeOffer(forItem: forItem, offeredItems: offeredItems, fromUser: fromUser, toUser: getAppUserFromUser(user), status: status, createdAt: createdAtTimestamp.dateValue(), updatedAt: updatedAtTimestamp.dateValue())
    }
    
    private func getUserFromRef(userRef user : DocumentReference) -> AppUser? {
        var result : AppUser?;
        user.getDocument() { userSnapshot, err in
            if let userData = userSnapshot?.data() {
                guard let email = userData["email"] as? String else {
                    return;
                }
                guard let displayName = userData["displayName"] as? String else {
                    return;
                }
                result = AppUser(uid: UUID(uuidString: user.documentID)!, email: email, displayName: displayName)
            }
        }
        return result;
    }
    
    private func getTradeItemFromRef(itemRef ref : DocumentReference) -> TradeItem? {
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
    
    private func getAppUserFromUser(_ user : User) -> AppUser {
        return AppUser(uid: UUID(uuidString: (user.uid))!, email: user.email, displayName: user.displayName)
    }
}
