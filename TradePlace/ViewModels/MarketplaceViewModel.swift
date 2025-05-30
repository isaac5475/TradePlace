import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@MainActor
class MarketplaceViewModel: ObservableObject {
    @Published var marketplaceItems: [TradeItem] = []

    func fetchMarketplaceItems() {
        
        let user = Auth.auth().currentUser!;
        let db = Firestore.firestore()
        let currentUserRef = db.document("Users/\((Utils.uuid(from: user.uid).uuidString))")

        db.collectionGroup("TradeItems")
            .whereField("isPostedOnMarketplace", isEqualTo: true)
            .whereField("belongsTo", isNotEqualTo: currentUserRef)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Firestore fetch error: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No TradeItems found.")
                    return
                }

                Task {
                    var fetchedItems: [TradeItem] = []
                    for document in documents {
                        let item = await TradeItem.fetchTradeItem(document.reference, fetchImages: true)
                            if let item = item {
                                fetchedItems.append(item)
                            } else {
                                print("⚠️ Could not fetch TradeItem with id \(document.documentID)")
                            }
                    }

                    self.marketplaceItems = fetchedItems
                }
            }
    }

    init() {
        fetchMarketplaceItems()
    }
}
