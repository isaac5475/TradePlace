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
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                ],
                alignment: .center
            ) {
                ForEach(marcetplaceItems) { item in
                        VStack {
                            NavigationLink(destination:ItemdetailsView(item:item)){
                                Image(systemName: item.imageNames.first!)
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
