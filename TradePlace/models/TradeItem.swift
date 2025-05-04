//
//  TradeItem.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import SwiftUICore

struct TradeItem {
    let id = UUID();
    let photos : [Image];
    let title: String;
    let description: String;
    let estimatedPrice: Double;
    let lookingFor: String;
    var isPosted: Bool;
    //let belongsTo: User;
}


