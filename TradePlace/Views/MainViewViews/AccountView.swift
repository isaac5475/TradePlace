//
//  AccountView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Shows all account informations

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
            SignOutOfGoogleButton {
                Task {
                    viewModel.signOut();
                    //coordinator.isSignedIn = false
                }
            }
    }
}

import SwiftUI

struct SignOutOfGoogleButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            
            HStack {
                Image("google-logo1")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 10)

                Text("Sign Out of Google")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AccountView()
}
