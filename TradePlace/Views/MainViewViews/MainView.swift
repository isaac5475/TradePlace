//
//  MainView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// The main view of the app with navigation to the Marketplace, Your Offers, Your Items and  Account.

import SwiftUI


struct MainView: View {

    @EnvironmentObject var coordinator : NavigationCoordinator;

    var body: some View {
            TabView {
                MarketplaceView()
                    .tabItem {
                        Label("Marketplace", systemImage: "magnifyingglass")
                    }

                YourOffersView()
                    .tabItem {
                        Label("Your Offers", systemImage: "megaphone")
                    }

                ItemCreationView()
                    .tabItem {
                        Label("New Item", systemImage: "plus")
                    }

                YourItemsView()
                    .tabItem {
                        Label("Your Items", systemImage: "clipboard")
                    }

                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person")
                    }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(
                isPresented: $coordinator.goToItemChange
            ) {
                ItemChangeView(item: coordinator.itemToEdit, onSave: { updatedItem in
                    // Replace the old item with the edited one
//                            if let index = marketplaceItems.firstIndex(where: { $0.id == updatedItem.id }) {
//                                marketplaceItems[index] = updatedItem
//                            }
                })
            }
            .navigationDestination(isPresented: $coordinator.goToYourOffers) {
                YourOffersView()
            }
        }
}

#Preview {
    MainView()
}
