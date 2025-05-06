//
//  ItemCreationView.swift
//  TradePlace
//
//  Created by Jan Huecking on 1/5/2025.
//
// Allows users to create a new item and add it to their personal item pool.

import PhotosUI
import SwiftUI

struct ItemCreationView: View {

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var estimatedPrice: String = ""
    @State private var lookingFor: String = ""
    @State private var isPosted: Bool = false

    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    @Environment(\.dismiss) private var dismiss
        
    @StateObject private var viewModel = ItemCreationViewModel();

    var body: some View {
        ScrollView {
            //Heading
            Text("New Item")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)

            VStack(alignment: .leading) {

                //Images
                //Preview of the selected Images
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<selectedImages.count, id: \.self) { i in
                            selectedImages[i]
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                        }
                    }
                }
                // Button to select Images
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.caption)
                            Text("Select Images")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                )
                .padding(.bottom, 20)

                //Title
                Text("Title")
                TextField("Enter a Title", text: $title)
                    .padding(.bottom, 20)

                Text("Description")
                TextEditor(text: $description)
                    .frame(minHeight: 80, maxHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .padding(.bottom, 20)

                // Estimated Price of the item
                HStack {
                    Text("Estimated Price")
                    Spacer()
                    Text("$")
                        .font(.title3)
                    TextField("0", text: $estimatedPrice)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                }
                .padding(.bottom, 20)

                // Items user is looking for
                Text("Looking for")
                TextField("Enter items you are looking for", text: $lookingFor)
                    .padding(.bottom, 20)

                // Select if item should be posted to marketplace
                Toggle("Post to Marketplace", isOn: $isPosted)
                    .padding(.bottom, 20)
                    .padding(.trailing)

                //Buttons to cancel and save the item, saving is only possible if images are selected and title, description are entered
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        if (viewModel.isSubmitting) {
                            return;
                        }
                        let newItem = TradeItem(
                            images: selectedImages,
                            title: title,
                            description: description,
                            estimatedPrice: Double(estimatedPrice) ?? 0.0,
                            preferences: lookingFor,
                            isPostedOnMarketplace: isPosted
                        )
                        viewModel.isSubmitting = true;
                        Task {
                            do {
                                try await viewModel.handleSubmit(toSubmit: newItem)
                            } catch {
                                viewModel.couldntSubmit = true
                                // TODO notify about error
                            }
                        }
                        viewModel.isSubmitting = false;
                        viewModel.shouldNavigateToYourItems = true
                    } label: {
                        Text("Save Item")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        title.isEmpty || description.isEmpty || viewModel.isSubmitting)
                }
                .padding(.top)
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        // If the user selects new images, the old ones are removed to avoid duplications and the new are loaded in
        .onChange(of: selectedItems) {
            Task {
                selectedImages.removeAll()

                for item in selectedItems {
                    if let image = try? await item.loadTransferable(
                        type: Image.self)
                    {
                        selectedImages.append(image)
                    }
                }

            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToYourItems) {
            YourItemsView(uuid: UUID())
        }
    }
}

#Preview {
    ItemCreationView()
}
