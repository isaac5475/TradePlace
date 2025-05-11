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

    func fetchYourOffers() async {
        guard let user = Auth.auth().currentUser else { return }
        let userId = Utils.uuid(from: user.uid).uuidString
        let db = Firestore.firestore()
        let offersRef = db.collection("Users").document(userId).collection("TradeOffers")

        do {
            let snapshot = try await offersRef.getDocuments()
            var offers: [TradeOffer] = []

            for doc in snapshot.documents {
                if let offer = await TradeOffer.fetchTradeOffer(doc.reference) {
                    offers.append(offer)
                }
            }
            self.userOffers = offers
        } catch {
            print("Failed to fetch trade offers: \(error)")
        }
    }
}
