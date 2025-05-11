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
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Spacer()
                
                VStack() {
                    Image("appIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)

                    Text("Welcome to TradePlace")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 100)

                    
                    ContinueWithGoogleButton {
                        Task {
                            await viewModel.signInWithGoogle()
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                MainView()
            }
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

                Text("Sign in with Google")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    AuthView()
}
