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

struct CreateOfferPageView: View {
    let targetItem: TradeItem;
    @StateObject private var viewModel = CreateOfferPageViewModel();
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator : NavigationCoordinator;

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Items")
                .font(.title2)
                .bold()
                .padding()
            if viewModel.userItems.isEmpty {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.userItems, id: \.id) { item in
                            ItemSelectionBox(item: item, isSelected: viewModel.selectedItemIDs.contains(item.id)) {
                                if viewModel.selectedItemIDs.contains(item.id) {
                                    viewModel.selectedItemIDs.remove(item.id)
                                } else {
                                    viewModel.selectedItemIDs.insert(item.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()

            Button {
                Task {
                    do {
                        let selectedItems = viewModel.userItems.filter { usrItm in viewModel.selectedItemIDs.contains(usrItm.id) }
                        if let offer = await viewModel.createTradeOffer(toUser: targetItem.belongsTo, forItem: targetItem, offeredItems: selectedItems) {
                            try await viewModel.sendOffer(offer)
                        } else {
                            print("couldn't create offer")
                        }
                    } catch {
                        print("error to send offer: \(error)")
                    }
                }
                coordinator.goToYourOffers = true;

            } label: {
                Text("Offer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedItemIDs.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(viewModel.selectedItemIDs.isEmpty)
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchUserItems()
            }
        }
        .navigationTitle("Make an Offer")
    }

    
}
