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
    @StateObject private var viewModel : CreateOfferPageViewModel
    @Environment(\.dismiss) private var dismiss

    init(targetItem item: TradeItem) {
        _viewModel = StateObject(wrappedValue: CreateOfferPageViewModel(item))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Items")
                .font(.title2)
                .bold()
                .padding()

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

            Spacer()

            Button {
                Task {
                    do {
                        try await viewModel.sendOffer()
                    } catch {
                        print("error to send offer: \(error)")
                    }
                }
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
