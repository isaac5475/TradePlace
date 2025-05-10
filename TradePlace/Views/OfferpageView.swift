//
//  OfferpageView.swift
//  TradePlace
//
//  Created by Sahil Chopra on 10/5/2025.
//
// If the user wants to offer a trade, here he can select items he wants to suggest.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct OfferPageView: View {
    let targetItem: TradeItem
    @State private var userItems: [TradeItem] = []
    @State private var selectedItemIDs: Set<UUID> = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Items")
                .font(.title2)
                .bold()
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(userItems, id: \.id) { item in
                        ItemSelectionBox(item: item, isSelected: selectedItemIDs.contains(item.id)) {
                            if selectedItemIDs.contains(item.id) {
                                selectedItemIDs.remove(item.id)
                            } else {
                                selectedItemIDs.insert(item.id)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                sendOffer()
            }) {
                Text("Offer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedItemIDs.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(selectedItemIDs.isEmpty)
            .padding()
        }
        .onAppear {
            fetchUserItems()
        }
        .navigationTitle("Make an Offer")
    }

    private func fetchUserItems() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("items")
            .whereField("ownerID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self.userItems = docs.compactMap {
                    try? $0.data(as: TradeItem.self)
                }
            }
    }

    private func sendOffer() {
        guard let currentUser = Auth.auth().currentUser else { return }

        let fromUser = AppUser(id: currentUser.uid,
                               email: currentUser.email ?? "",
                               displayName: currentUser.displayName ?? "Unnamed")

        let toUser = AppUser(id: targetItem.ownerID,
                             email: "", // Fill from DB if needed
                             displayName: "") // Fill from DB if needed

        let offeredItems = userItems.filter { selectedItemIDs.contains($0.id) }

        let offer = TradeOffer(
            fromUser: fromUser,
            toUser: toUser,
            requestedItem: targetItem,
            offeredItems: offeredItems,
            createdAt: Date(),
            updatedAt: Date()
        )

        do {
            try Firestore.firestore()
                .collection("tradeOffers")
                .document(offer.id)
                .setData(from: offer)

            dismiss()
        } catch {
            print("Error sending offer: \(error)")
        }
    }
}
