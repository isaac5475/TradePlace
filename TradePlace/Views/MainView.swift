//
//  MainView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//

import SwiftUI

// Sample Data
struct Item: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}
let sampleItems = [
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
    Item(title: "Bicycle", imageName: "bike"),
    Item(title: "Guitar", imageName: "guitar"),
    Item(title: "Camera", imageName: "camera"),
]

struct MainView: View {
    var body: some View {
        NavigationStack {
            TabView {

                MarcetplaceView()
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

struct MarcetplaceView: View {

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
                ForEach(sampleItems) { item in
                    VStack {
                        Image(systemName: "square")
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                        Text(item.title)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct YourOffersView: View {
    var body: some View {
            Text("Your Offers will appear here.")
    }
}

struct YourItemsView: View {
    var body: some View {
            Text("Your Items will appear here.")
    }
}

struct AccountView: View {
    var body: some View {
            Text("Your Account will appear here.")
        }
    }

#Preview {
    MainView()
}
