//
//  ContentView.swift
//  TradePlace
//
//  Created by Murat Zaydullin on 29/4/2025.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            Button("Get data") {
                print("get data clicked")
                Task {
                    print("getting document")
                    await getData()
                }
            }
            Button("upload data") {
                Task {
                    await writeData()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
