//
//  TradeOffer.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation

struct TradeOffer {
    let id = UUID();
    let forItem: TradeItem;
    var offeredItems: [TradeItem];
    //let fromUser: User;
    //let toUser: User;
    var status: TradeOfferStatus;
    let createdAt: Date;
    var updatedAt: Date;
}

enum TradeOfferStatus {
    case CREATED, CANCELLED, ACCEPTED;
}
