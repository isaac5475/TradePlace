//
//  AppUser.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AppUser {
    let id = UUID();
    let uid : UUID;
    let email: String?;
    let displayName: String?
    
    init(uid: UUID = UUID(), email: String?, displayName: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}


func getUserFromRef(userRef user : DocumentReference) -> AppUser? {
    var result : AppUser?;
    user.getDocument() { userSnapshot, err in
        if let userData = userSnapshot?.data() {
            guard let email = userData["email"] as? String else {
                return;
            }
            guard let displayName = userData["displayName"] as? String else {
                return;
            }
            result = AppUser(uid: UUID(uuidString: user.documentID)!, email: email, displayName: displayName)
        }
    }
    return result;
}

func getAppUserFromUser(_ user : User) -> AppUser {
    return AppUser(uid: UUID(uuidString: (user.uid))!, email: user.email, displayName: user.displayName)
}

