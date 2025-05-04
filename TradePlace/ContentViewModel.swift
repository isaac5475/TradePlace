//
//  ContentViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 4/5/2025.
//

import Firebase
import FirebaseFirestore

let db = Firestore.firestore()

func getData() async {
    do {
        let snapshot = try await db.collection("TradeItem").getDocuments();
        for document in snapshot.documents {
            print("\(document.documentID) => \(document.data())")
        }
    }
    catch {
        print("Error getting a document: \(error)")
    }
}

func writeData() async {
    do {
        let ref = try await db.collection("TradeItem")
            .addDocument(data: [
                "description": "lorem ipsum",
                "estimatedPrice": 600.0,
                "isPostedOnMarketplace": false,
                "photos": [],
                "preferences": "Another test"
            ])
    } catch {
        print("Error writing in a document: \(error)")

    }
}
