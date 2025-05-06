//
//  NavigationCoordinator.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//
import Foundation

class NavigationCoordinator : ObservableObject {
    @Published var goToItems = false;
    @Published var itemToEdit : TradeItem = TradeItem(id: UUID(), images: [], title: "", description: "", estimatedPrice: 0.0, preferences: "", isPostedOnMarketplace: false) //  dummy
    @Published var goToItemChange = false
}
