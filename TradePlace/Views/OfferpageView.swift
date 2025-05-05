//
//  OfferpageView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// If the user wants to offer a trade, here he can select items he wants to suggest.

import SwiftUI

struct OfferpageView: View {
    @State private var selectedItems: Set<UUID> = []
    var userItems: [TradeItem] = userOwnedItems // Assuming this exists globally or passed in

    var body: some View {
        VStack {
            Text("Select Items to Offer")
                .font(.largeTitle)
                .bold()
                .padding()

            List(userItems, id: \.id, selection: $selectedItems) { item in
                HStack {
                    if let img = item.images.first {
                        img
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                    Text(item.title)
                }
            }
            .environment(\.editMode, .constant(.active)) // Enable multi-select

            Button(action: {
                // Logic to submit offer
                // For example: create a TradeOffer and save it
            }) {
                Text("Submit Offer")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedItems.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            .disabled(selectedItems.isEmpty)
        }
    }
}
