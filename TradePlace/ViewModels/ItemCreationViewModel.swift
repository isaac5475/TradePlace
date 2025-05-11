//
//  ItemCreationViewModel.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ItemCreationViewModel : ObservableObject {
    
    @Published var isSubmitting = false;
    @Published var couldntSubmit : Bool? = nil;
    @Published var shouldNavigateToYourItems = false;
    
    let user = Auth.auth().currentUser!;
    
    func handleSubmit(toSubmit item : TradeItem, images data: [Data]) async throws {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        for (index, image) in data.enumerated() {
            let imageRef = storageRef.child("\(item.id.uuidString)/\(index).jpg")
            imageRef.putData(image, metadata: nil)
        }
        
        let db = Firestore.firestore()
        let tradeItemsForUser = db.collection("Users").document(Utils.uuid(from: user.uid).uuidString).collection("TradeItems");
        let belongsToRef = try await db.collection("Users").document(item.belongsTo.id.uuidString).getDocument().reference;
        try await tradeItemsForUser.document(item.id.uuidString).setData([
            "title": item.title,
            "description": item.description,
            "estimatedPrice": item.estimatedPrice,
            "isPostedOnMarketplace": item.isPostedOnMarketplace,
            "preferences": item.preferences,
            "belongsTo": belongsToRef
        ])
    }

    func getItemOwner() async -> AppUser? {
        let uid = Utils.uuid(from: user.uid);
        print("fetching user for uid:", uid.uuidString)
        return await AppUser.fetchUser(userId: uid);
    }
}


func compressToJpegData(_ data: Data, compressionQuality: CGFloat) -> Data? {
    if let image = UIImage(data: data) {
        return image.jpegData(compressionQuality: compressionQuality);
    }
    return nil;
}
