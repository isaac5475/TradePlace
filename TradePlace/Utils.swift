//
//  Utils.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import Foundation
import CryptoKit

class Utils {
    static func uuid(from uuid: String) -> UUID {
        let h = SHA256.hash(data: Data(uuid.utf8))
        let hash = Array(h)
        let uid = UUID(uuid: (
            hash[0], hash[1], hash[2], hash[3],
            hash[4], hash[5], hash[6], hash[7],
            hash[8], hash[9], hash[10], hash[11],
            hash[12], hash[13], hash[14], hash[15]
        ));
        return uid;
    }
}
