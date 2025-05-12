//
//  YourOffersViewModel.swift
//  TradePlace
//
//  Created by Sahil Chopra on 11/05/2025.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class YourOffersViewModel: ObservableObject {
    @Published var userOffers: [TradeOffer] = []
    let user = Auth.auth().currentUser!

    func fetchYourOffers() async {
        let userId = Utils.uuid(from: user.uid).uuidString
        let db = Firestore.firestore()
        let offersRef = db.collection("Users").document(userId).collection("TradeOffers")

        do {    //  fetch offers offered TO the current user
            let snapshot = try await offersRef.getDocuments()
            var offers: [TradeOffer] = []

            for doc in snapshot.documents {
                if let offer = await TradeOffer.fetchTradeOffer(doc.reference) {
                    offers.append(offer)
                }
            }
            
                //  fetch offers offered BY the current user
                let currentUserRef = db.document("Users/\(Utils.uuid(from: user.uid))")
                let snapshot2 = try await db.collectionGroup("TradeOffers")
                    .whereField("fromUser", isEqualTo: currentUserRef)
                    .getDocuments()
            for doc in snapshot2.documents {
                if let offer = await TradeOffer.fetchTradeOffer(doc.reference) {
                    offers.append(offer)
                }
                print("fetched offers offered by curr user: \(snapshot2.count)")
            }
            offers = offers.sorted { $0.updatedAt > $1.updatedAt}
            self.userOffers = offers
        } catch {
            print("Failed to fetch trade offers: \(error)")
        }
    }
}
