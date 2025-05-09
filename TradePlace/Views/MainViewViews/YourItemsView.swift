//
//  YourItemsView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Shows all items the user owns and has uploaded to the app. It also shows if the item is posted on the marcetplace. The user can edit his items by clicking on it and can add items.

import SwiftUI

struct YourItemsView: View {
    
    @StateObject private var viewModel = YourItemsViewModel()
    @EnvironmentObject var coordinator : NavigationCoordinator;

    @State var uuid = UUID();   //  update this to trigger reload
    var body: some View {
        ScrollView {
            
            // Heading
            Text("Your Items")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
 
            // Grid for showing the items
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                    GridItem(.flexible(minimum: 50, maximum: .infinity)),
                ],
                alignment: .center
            ) {
                ForEach(viewModel.items) { item in
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            
                                if let img = item.images.first {
                                    img
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .padding(8)
                                        
                                    
                                } else {
                                    Image("no-image")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .padding(8)
                                }
                            
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        .onTapGesture {
                            coordinator.goToItemChange = true
                            coordinator.itemToEdit = item
                                    }
                        

                        // All items that are posted on marketplace are signed by a green badge
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
                
                //Button to add an item
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
            }
            .padding(3)
        }
        .refreshable {
            await viewModel.fetchItems();
            await viewModel.fetchItemImages();
        }
    }
}

#Preview {
    YourItemsView()
}
