import Foundation
import FirebaseFirestore
import FirebaseStorage

@MainActor
class MarketplaceViewModel: ObservableObject {
    @Published var marketplaceItems: [TradeItem] = []

    func fetchMarketplaceItems() {
        let db = Firestore.firestore()
        db.collectionGroup("TradeItems")
            .whereField("isPostedOnMarketplace", isEqualTo: true)
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
                        let documentId = document.documentID
                        if let uuid = UUID(uuidString: documentId) {
                            let item = await TradeItem.parseTradeItem(tradeItemId: uuid, document.data())
                            if let item = item {
                                fetchedItems.append(item)
                            } else {
                                print("⚠️ Could not parse TradeItem with id \(documentId)")
                            }
                        } else {
                            print("⚠️ Invalid UUID for TradeItem ID: \(documentId)")
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
