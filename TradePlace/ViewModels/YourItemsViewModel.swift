//
//  YourItemsViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation
import SwiftUI

import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@MainActor
class YourItemsViewModel : ObservableObject {
   
    @Published var items : [TradeItem] = []
    @Published var isError = false;
    @Published var navigateToItemChangeView = false
    @Published var item : TradeItem = TradeItem(id: UUID(),
                                                images: [],
                                                title: "Test Item",
                                                description: "A description",
                                                estimatedPrice: 99.99,
                                                preferences: "Anything",
                                                isPostedOnMarketplace: true)
    
    let user = Auth.auth().currentUser!;

    init() {
        Task {
            await fetchItems();
        }
    }
    
    func fetchItemImages(itemUUID: UUID) async -> [Image] {
        var itemImages: [Image] = []
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let itemFolderRef = storageRef.child("\(itemUUID)");

        do {
                let fetchedImages = try await itemFolderRef.listAll()
                print("Downloading images for \(itemUUID)")

                for imageRef in fetchedImages.items {
                    print("Downloading...")
                    do {
                        let data = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
                            imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                                if let error = error {
                                    continuation.resume(throwing: error)
                                } else if let data = data {
                                    continuation.resume(returning: data)
                                }
                            }
                        }

                        if let uiImage = UIImage(data: data) {
                            itemImages.append(Image(uiImage: uiImage))
                            print("Added image to itemImages")
                        }

                    } catch {
                        print("Error downloading image: \(error)")
                    }
                }

            } catch {
                print("Error: could not get item images from Firebase storage: \(error)")
            }

        return itemImages
    }
    
    func fetchItems() async {
        let db = Firestore.firestore()
        do {
            let itemsForUser = try await db.collection("Users").document(user.uid).collection("TradeItems").getDocuments()
            var items : [TradeItem] = []
            for document in itemsForUser.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "";
                let description = data["description"] as? String ?? "";
                let preferences = data["preferences"] as? String ?? "";
                let estimatedPrice = data["estimatedPrice"] as? Double ?? 0.0
                let isPostedOnMarketplace = data["isPostedOnMarketplace"] as? Bool ?? false
                let tradeItem = await TradeItem(id: UUID(uuidString: document.documentID)!, images: fetchItemImages(itemUUID: UUID(uuidString: document.documentID)!), title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace)
                
                
                items.insert(tradeItem, at: 0)
            }
            self.items = items;
        } catch {
            isError = true;
        }
    }
}
