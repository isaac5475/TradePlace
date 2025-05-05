//
//  ItemDetailsView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Shows details of an item selected from the Marketplace. Gives the option to offer a trade if the user likes the item.

import SwiftUI

struct ItemDetailsView: View {
    var item: TradeItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {

                // Images
                //  TODO: change to process images, show empty image if the array is empty
                
//                TabView {
//                    ForEach(item.imageNames, id: \.self) { imageName in
//                        Image(systemName: imageName)
//                            .resizable()
//                            .scaledToFit()
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle())
//                .indexViewStyle(.page(backgroundDisplayMode: .always))
//                .frame(height: 250)

                // Title
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Description
                Text(item.description)
                    .font(.body)

                // Looking for
                HStack {
                    Text("Looking for:")
                        .font(.headline)

                    Text(item.preferences)
                }

                // Estimated price
                HStack {
                    Text("Estimated Price:")
                        .font(.headline)
                    
                    Text("$\(item.estimatedPrice, specifier: "%.2f")")
                        .font(.body)
                    
                }
                Spacer()
            }
        }
        .padding([.horizontal, .top])
        
//         Trade Button
        NavigationLink(destination: OfferpageView()) {
            Text("Trade")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding([.horizontal, .bottom])
            
        }
    }

}

#Preview {
    ItemDetailsView(
        item: TradeItem(
            images: [], title: "Bicycle",
            description:
                "A sturdy mountain bike, perfect for trails and city commutes.",
            estimatedPrice: 300.0,
            preferences: "everything", isPostedOnMarketplace: true))
}
