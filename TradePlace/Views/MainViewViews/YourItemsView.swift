//
//  YourItemsView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Shows all items the user owns and has uploaded to the app. It also shows if the item is posted on the marcetplace. The user can edit his items by clicking on it and can add items.

import SwiftUI

struct YourItemsView: View {
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
                ForEach(yourItems) { item in
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            Image(systemName: item.imageNames.first!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .padding(8)

                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)

                        if item.isPostedOnMarketplace {
                            Text("Posted")
                                .font(.system(size: 11))
                                .padding(5)
                                .background(Color.green.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .padding(5)
                        }
                    }
                }
                NavigationLink(destination: ItemCreationView()){
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }.padding(3)
        }
    }
}

#Preview {
    YourItemsView()
}
