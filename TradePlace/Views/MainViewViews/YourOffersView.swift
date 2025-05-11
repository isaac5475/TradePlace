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
    @State private var yourOffers : [TradeOffer] = []
    @StateObject var viewModel = YourOffersViewModel();
    
    var body: some View {

        // Creating a tap for each offer so that the user can swipe horizontaly to view the offers
        TabView {
            ForEach(yourOffers) { offer in
                VStack{
                    // Heading
                    Text("Your Offers")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)
                        .padding(.top)
                
                    Spacer()
                    
                    Text("\(offer.fromUser.displayName!) suggests:")
                        .font(.title)
                        .bold()
                    
                    List(offer.offeredItems) { offeredItem in
                        Text(offeredItem.title)
                            .font(.title3)
                            .padding()
                        
                        Spacer()
                        
                        // Buttons to decline and accept
                        HStack{
                            Button(action: {Task { await viewModel.declineOffer(offer)}}) {
                                
                                Text("Decline")
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {Task { await viewModel.acceptOffer(offer)}}) {
                                Text("Accept")
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 60)
                    }
                    .padding()
                }
                .onAppear {
                    Task {
                        await viewModel.fetchItems()
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchItems()
                    }
                }            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
