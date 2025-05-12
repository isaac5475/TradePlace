//
//  OfferPageViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import FirebaseAuth
import FirebaseFirestore

@MainActor
class CreateOfferPageViewModel : ObservableObject {
    
    @Published var userItems: [TradeItem] = []
    @Published var selectedItemIDs: Set<UUID> = []
    
    let currentUser = Auth.auth().currentUser
    
    func fetchUserItems() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.userItems = []
        do {
            let tradeItemsRefs = try await Firestore.firestore().collection("Users").document(Utils.uuid(from: userID).uuidString).collection("TradeItems").getDocuments()
            for doc in tradeItemsRefs.documents {
                if let tradeItem = await TradeItem.fetchTradeItem(doc.reference) {
                    self.userItems.append(tradeItem)
                }
            }
        } catch {
            print("Couldn't fetch TradeItem's for \(userID)")
        }
    }
    
    func createTradeOffer(toUser to : AppUser, forItem item: TradeItem, offeredItems items: [TradeItem]) async -> TradeOffer? {
        guard let currentUser = currentUser else { return nil }
        guard !items.isEmpty else { return nil; }
        let fromUser = AppUser.init(id: Utils.uuid(from: currentUser.uid), email: currentUser.email, displayName: currentUser.email)
        let fetchedToUser = await AppUser.fetchUser(userId: item.belongsTo.id)
        guard let toUser = fetchedToUser else {return nil;}
                
        return TradeOffer(
            forItem: item,
            offeredItems: items,
            fromUser: fromUser,
            toUser: toUser,
            status: TradeOfferStatus.CREATED,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    func sendOffer(_ offer: TradeOffer) async throws {
        try await TradeOffer.postTradeOffer(tradeOffer: offer)
    }
}
