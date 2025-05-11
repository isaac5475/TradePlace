//
//  AuthView.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false;
    init() {
        self.user = Auth.auth().currentUser
    }

    func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing client ID")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else {
                print("Missing root view controller")
                return
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            guard let idToken = result.user.idToken?.tokenString else {
                print("Missing ID token")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )

            let authResult = try await Auth.auth().signIn(with: credential)
            self.user = authResult.user
            isAuthenticated = true
            print("Signed in as: \(authResult.user.email ?? "Unknown")")
            let db = Firestore.firestore()
            let userId = Utils.uuid(from: authResult.user.uid)
            let docRef = db.collection("Users").document(userId.uuidString)
            do {
                let doc = try await docRef.getDocument();
                if !doc.exists {
                    try await docRef.setData([
                        "email": authResult.user.email ?? "",
                        "displayName": authResult.user.displayName ?? "",
                    ])
                }
            } catch {
                print("Couldn't save user to db")
            }
        } catch {
            print("Sign-in error: \(error.localizedDescription)")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
}
