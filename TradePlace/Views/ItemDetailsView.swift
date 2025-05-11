//
//  ItemDetailsView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Shows details of an item selected from the Marketplace. Gives the option to offer a trade if the user likes the item.

import SwiftUI

struct ItemDetailsView: View {
    let item: TradeItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let firstImage = item.images.first {
                    firstImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(12)
                }

                Text(item.title)
                    .font(.title)
                    .bold()

                Text(item.description)
                    .font(.body)

                HStack {
                    Text("Estimated Price:")
                        .bold()
                    Text("$\(item.estimatedPrice, specifier: "%.2f")")
                }

                HStack {
                    Text("Preferences:")
                        .bold()
                    Text(item.preferences)
                }

                NavigationLink(destination: CreateOfferPageView(targetItem: item)) {
                    Text("Make Offer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 24)
            }
            .padding()
        }
        .navigationTitle("Item Details")
    }
}


#Preview {
    ItemDetailsView(
        item: TradeItem(
            images: [], title: "Bicycle",
            description:
                "A sturdy mountain bike, perfect for trails and city commutes.",
            estimatedPrice: 300.0,
            preferences: "everything", isPostedOnMarketplace: true, belongsTo: AppUser(id: UUID(), email: "bob@test.omc", displayName: "Bob")))
}
