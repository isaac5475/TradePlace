//
//  YourOffersView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Allows the user to swipe horizontally through offers made by other users.
// Each offer shows suggested items, the item they want, and two buttons to accept or decline the offer.

import SwiftUI

struct YourOffersView: View {
    @StateObject private var viewModel = YourOffersViewModel()

    var body: some View {
        VStack {
            Text("Your Offers")
                .font(.largeTitle)
                .bold()
                .padding()

            if viewModel.userOffers.isEmpty {
                Text("No offers made yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                TabView {
                    ForEach(viewModel.userOffers, id: \.id) { offer in
                        OfferCardView(offer: offer, viewModel: viewModel)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        .onAppear {
            Task { await viewModel.fetchYourOffers() }
        }
    }
}

struct OfferCardView: View {
    let offer: TradeOffer
    @StateObject var viewModel : YourOffersViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Offered Items:")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(offer.offeredItems, id: \.id) { item in
                        VStack {
                            if let image = item.images.first {
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(6)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                            }
                            Text(item.title)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Text("In Exchange For:")
                .font(.headline)
            Text(offer.forItem.title)
                .font(.title3)
                .bold()
            if offer.status == .CREATED && offer.forItem.belongsTo.id == Utils.uuid(from: viewModel.user.uid) {
                HStack {
                    Button("Decline") {
                        Task {
                            TradeOffer.reject(offer)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
                    Button("Accept") {
                        Task {TradeOffer.accept(offer) }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
                }
            }
            Text("Status: \(offer.status.rawValue)")
                .foregroundColor(.blue)
                .padding(.top)

            Spacer()
        }
        .padding()
    }
}



#Preview {
    YourOffersView()
}
