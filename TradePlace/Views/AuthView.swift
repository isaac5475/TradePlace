//
//  AuthView.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 5/5/2025.
//

import SwiftUI
import UIKit
import GoogleSignIn

struct AuthView: View {
    
    @StateObject private var viewModel = AuthViewModel();
    
    var body: some View {
        VStack {
            ContinueWithGoogleButton {
                Task {
                    await viewModel.signInWithGoogle();
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            MainView()
        }
    }
}

import SwiftUI

struct ContinueWithGoogleButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image("google-logo1")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 10)

                Text("Continue with Google")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
#Preview {
    AuthView()
}
