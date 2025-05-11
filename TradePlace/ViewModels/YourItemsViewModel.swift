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
    
    let user = Auth.auth().currentUser!;

    init() {
        Task {
            await fetchItems();
            await fetchItemImages();
        }
    }
    
    func fetchItemImages() async {
        for index in items.indices {
            var itemImages = [Image]()
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let itemFolderRef = storageRef.child("\(items[index].id.uuidString)");
            
            do {
                let fetchedImages = try await itemFolderRef.listAll()
                //print("Downloading images for \(items[index].id.uuidString)")

                    for imageRef in fetchedImages.items {
                        //print("Downloading...")
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
                                //print("Added image to itemImages")
                            }

                        } catch {
                            print("Error downloading image: \(error)")
                        }
                    }

                } catch {
                    print("Error: could not get item images from Firebase storage: \(error)")
                }
                //print("we have got the images for \(items[index].title)!")
                var updatedItem = items[index]
                updatedItem.images = itemImages
                items[index] = updatedItem
            }
        }
    
    func fetchItems() async {
        let db = Firestore.firestore()
        do {
            let itemsForUser = try await db.collection("Users").document(Utils.uuid(from: user.uid).uuidString).collection("TradeItems").getDocuments()
            var items : [TradeItem] = []
            for document in itemsForUser.documents {
                let data = document.data()
                let tradeItem = await TradeItem.parseTradeItem(tradeItemId: UUID(uuidString: document.documentID)!, data)
                if tradeItem != nil {
                    items.insert(tradeItem!, at: 0)
                } else {
                    continue;
                }
            }
            self.items = items;
        } catch {
            isError = true;
        }
    }
}
