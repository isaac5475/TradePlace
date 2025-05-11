//
//  MarketplaceViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import Foundation

class MarketplaceViewModel : ObservableObject {
    @Published var items : [TradeItem] = []
    
    func fetchTradeItems() async {
        //  TODO fetch all TradeItems that has isPostedOnMarketplace = true
    }
}
