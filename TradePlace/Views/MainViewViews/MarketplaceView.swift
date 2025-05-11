//
//  MarketplaceView.swift
//  TradePlace
//
//  Created by Sahil Chopra on 11/5/2025.
//
// Displays all marketplace items in a grid layout.

import SwiftUI
import FirebaseStorage

struct MarketplaceView: View {
    @StateObject private var viewModel = MarketplaceViewModel()

    var body: some View {
        ScrollView {
            Text("Marketplace")
                .font(.largeTitle)
                .bold()
                .padding()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.marketplaceItems, id: \.id) { item in
                    NavigationLink(destination: ItemDetailsView(item: item)) {
                        VStack {
                            if let image = item.images.first {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(8)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 120)
                                    .cornerRadius(8)
                            }
                            Text(item.title)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                }
            }
            .padding()
        }
    }
}
