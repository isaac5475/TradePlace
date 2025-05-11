//
//  AppUser.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 11/5/2025.
//

import Foundation
import FirebaseFirestore

struct AppUser {
    let id : UUID;
    let email: String?;
    let displayName: String?
    
    init(id: UUID = UUID(), email: String?, displayName: String?) {
        self.id = id
        self.email = email
        self.displayName = displayName
    }
    
    static func fetchUser(userRef ref: DocumentReference) async -> AppUser? {
        do {
            let document = try await ref.getDocument();
            guard let data = document.data() else { return nil; }
            let email = data["email"] as? String;
            let displayName = data["displayName"] as? String;
            guard let userId = ref.path.split(separator: "/").last else { return nil; }
            guard let uuid = UUID(uuidString: String(userId)) else {return nil;}
            return AppUser(id: uuid, email: email, displayName: displayName)

        } catch {
            return nil;
        }
    }
    
    static func fetchUser(userId id: UUID) async -> AppUser? {
        let db = Firestore.firestore()
        do {
            let ref = try await db.collection("Users").document(id.uuidString).getDocument().reference;
            return await AppUser.fetchUser(userRef: ref)
        } catch {
            return nil;
        }
    }
}
