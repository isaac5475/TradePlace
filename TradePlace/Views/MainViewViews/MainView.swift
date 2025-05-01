//
//  MainView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// The main view of the app with navigation to the Marketplace, Your Offers, Your Items and the Account.

import SwiftUI

// Sample items
struct Item: Identifiable {
    let id = UUID()
    let title: String
    let imageNames: [String]
    let description: String
    let estimatedPrice: Double
    let isPostedOnMarketplace: Bool
    let lookingFor: String
}
let marcetplaceItems = [
    Item(title: "Bicycle", imageNames: ["bicycle", "square"], description: "hi", estimatedPrice: 40.0, isPostedOnMarketplace: true, lookingFor: "everything"),
    Item(title: "Guitar", imageNames: ["note"], description: "hi", estimatedPrice: 40.0,isPostedOnMarketplace: true, lookingFor: "everything"),
    Item(title: "Camera", imageNames: ["camera"], description: "hi", estimatedPrice: 40.0,isPostedOnMarketplace: true, lookingFor: "everything"),
]
let yourItems: [Item] = [
    Item(title: "Guitar", imageNames: ["square"], description: "hi", estimatedPrice: 40.0,isPostedOnMarketplace: true, lookingFor: "everything"),
    Item(title: "PC", imageNames: ["mail"], description: "hi", estimatedPrice: 40.0,isPostedOnMarketplace: false, lookingFor: "everything"),
    Item(title: "Shoes", imageNames: ["shoe"], description: "hi", estimatedPrice: 40.0,isPostedOnMarketplace: true, lookingFor: "everything"),
]

struct MainView: View {
    var body: some View {
        NavigationStack {
            TabView {

                MarketplaceView()
                    .tabItem {
                        Label("Marcetplace", systemImage: "magnifyingglass")
                    }

                YourOffersView()
                    .tabItem {
                        Label("Your Offers", systemImage: "megaphone")
                    }

                NavigationLink("This is item creation view") {}
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
        }
    }
}

#Preview {
    MainView()
}
