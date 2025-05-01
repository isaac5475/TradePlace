//
//  YourOffersView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// 

import SwiftUI

// Sample offers
struct Offer: Identifiable {
    let id = UUID()
    let forItem: String
    var offeredItems: String
    let fromUser: String
    let toUser: String
}
let sampleOffers = [
    Offer(forItem: "Auto1", offeredItems: "PC", fromUser: "Bob1", toUser: "You"),
    Offer(forItem: "Auto2", offeredItems: "PC", fromUser: "Bob2", toUser: "You")
]

struct YourOffersView: View {
    var body: some View {
        TabView {
            ForEach(sampleOffers) { offer in
                OfferPageView(offer: offer)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OfferPageView: View {
    let offer: Offer
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("\(offer.fromUser) suggests:")
                .font(.title)
                .bold()
            
            Text(offer.offeredItems)
                .font(.title3)
                .padding()
            
            Spacer()
            
            Text("For your item:")
                .font(.title)
                .bold()

            Text(offer.forItem)
                .font(.title3)
                .padding()

            Spacer()

            HStack{
                Button(action: {}) {
                    Text("Decline")
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button(action: {}) {
                    Text("Accept")
                        .font(.title3)
                        .frame(maxWidth: .infinity, minHeight: 80)
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
