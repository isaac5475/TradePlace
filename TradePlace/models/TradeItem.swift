//
//  TradeItem.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import Foundation
import SwiftUICore
import FirebaseFirestore
import FirebaseStorage

struct TradeItem : Identifiable {
    let id : UUID
    var images : [Image];
    var title: String;
    var description: String;
    var estimatedPrice: Double;
    var preferences: String;
    var isPostedOnMarketplace: Bool;
    let belongsTo: AppUser;
    
    init(
        id: UUID = UUID(),
        images: [Image],
        title: String,
        description: String,
        estimatedPrice: Double,
        preferences: String,
        isPostedOnMarketplace: Bool,
        belongsTo: AppUser
    ) {
        self.id = id
        self.images = images
        self.title = title
        self.description = description
        self.estimatedPrice = estimatedPrice
        self.preferences = preferences
        self.isPostedOnMarketplace = isPostedOnMarketplace
        self.belongsTo = belongsTo
    }
    
    static func parseTradeItem(tradeItemId id: UUID, _ data: [String: Any]) async -> TradeItem? {
        let title = data["title"] as? String ?? "";
        let description = data["description"] as? String ?? "";
        let preferences = data["preferences"] as? String ?? "";
        let estimatedPrice = data["estimatedPrice"] as? Double ?? 0.0
        let isPostedOnMarketplace = data["isPostedOnMarketplace"] as? Bool ?? false
    
        guard let belongsToRef = data["belongsTo"] as? DocumentReference else {
            return nil;
        }
        guard let belongsTo = await AppUser.fetchUser(userRef: belongsToRef) else { return nil; }
        
        return TradeItem(id: id, images: [] /* images loaded in the background after to avoid slow loading of page */ , title: title, description: description, estimatedPrice: estimatedPrice, preferences: preferences, isPostedOnMarketplace: isPostedOnMarketplace, belongsTo: belongsTo)
    }
    
    static func fetchTradeItem(_ docRef: DocumentReference, fetchImages fetch : Bool = false) async -> TradeItem?{
        do {
            let data = try await docRef.getDocument()
            guard let data = data.data() else {return nil;}
            guard let documentId = docRef.path.split(separator: "/").last else {return nil;}    //  try to get the id of the trade item, which is stored in path
            let documentIdStr = String(documentId)
            var tradeItem = await TradeItem.parseTradeItem(tradeItemId: UUID(uuidString: documentIdStr)!, data)
            if fetch {
                await tradeItem?.fetchItemImages()
            }
            return tradeItem;
        } catch {
            return nil;
        }
    }
    
    mutating func fetchItemImages() async {
        var itemImages = [Image]()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let itemFolderRef = storageRef.child("\(self.id.uuidString)");
        
        do {
            let fetchedImages = try await itemFolderRef.listAll()
            
            for imageRef in fetchedImages.items {
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
        images = itemImages
    }
}

//var marketplaceItems = [
//    TradeItem(
//        images: [], title: "Bicycle", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Guitar", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Camera", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "Guitar2", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true),
//    TradeItem(
//        images: [], title: "PC", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: false),
//    TradeItem(
//        images: [], title: "Shoes", description: "hi",
//        estimatedPrice: 40.0, preferences: "everything", isPostedOnMarketplace: true
//    )
//]
