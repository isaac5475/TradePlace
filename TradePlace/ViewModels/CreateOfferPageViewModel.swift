//
//  OfferPageViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import FirebaseAuth
import FirebaseFirestore

class CreateOfferPageViewModel : ObservableObject {
    
    @Published var userItems: [TradeItem] = []
    @Published var selectedItemIDs: Set<UUID> = []
    let targetItem : TradeItem
    
    init(_ targetItem : TradeItem) {
        self.targetItem = targetItem
    }
    
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
        let fetchedFromUser = await AppUser.fetchUser(userId: UUID(uuidString: currentUser.uid)!)
        let fromUser : AppUser
        if fetchedFromUser != nil {
            fromUser = fetchedFromUser!;
        } else {
            fromUser = AppUser(email: currentUser.email, displayName: currentUser.displayName)
        }
        
        let fetchedToUser = await AppUser.fetchUser(userId: item.id)
        let toUser : AppUser
        if fetchedToUser != nil {
            toUser = fetchedToUser!;
        } else {
            return nil; //  Unlikely that we are making an offer to a user that is non existent in the db
        }
                
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
    
    func sendOffer() async throws {
        let selectedItems = self.userItems.filter { usrItm in self.selectedItemIDs.contains(usrItm.id) }
        if let offer = await createTradeOffer(toUser: targetItem.belongsTo, forItem: targetItem, offeredItems: selectedItems) {
            try await TradeOffer.postTradeOffer(tradeOffer: offer)
        }
    }
}
