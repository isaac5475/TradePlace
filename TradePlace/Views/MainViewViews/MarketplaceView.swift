//
//  MarketplaceView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Displays all marketplace items in a grid layout.

import SwiftUI

struct MarketplaceView: View {
    var body: some View {
        ScrollView {
            
            // Heading
            Text("Marketplace")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                ],
                alignment: .center
            ) {
                //Every Item listed on the marketplace will be added to the grid with its first image containing the link to its details and its title
                ForEach(marketplaceItems) { item in
                        VStack {
                            NavigationLink(destination:ItemDetailsView(item:item)){
                                Image(item.images.first!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding(8)
                            }
                            .foregroundStyle(.black)
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        
                }
            }.padding(3)
        }
    }
}

#Preview {
    MarketplaceView()
}
