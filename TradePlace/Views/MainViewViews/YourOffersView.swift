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
    @StateObject private var viewModel = YourOffersViewModel();
    var body: some View {

        // Creating a tap for each offer so that the user can swipe horizontaly to view the offers
        TabView {
            ForEach(viewModel.yourOffers) { offer in
                OfferPageView(offer: offer)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

// View of the offer itself
struct OfferPageView: View {
    let offer: TradeOffer
    
    var body: some View {
       
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
            }
            Spacer()
            
            Text("For your item:")
                .font(.title)
                .bold()

            Text(offer.forItem.title)
                .font(.title3)
                .padding()

            Spacer()

            // Buttons to decline and accept
            HStack{
                Button(action: {}) {
                    
                    Text("Decline")
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button(action: {}) {
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
}


#Preview {
    YourOffersView()
}
