//
//  ItemChangeView.swift
//  TradePlace
//
//  Created by Jan Huecking on 5/5/2025.
//
// Allows users to change their existing items or delete them.

import SwiftUI
import _PhotosUI_SwiftUI

struct ItemChangeView: View {

    @State var item: TradeItem
    var onSave: (TradeItem) -> Void

    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    @State private var estimatedPriceInput = "";
    @Environment(\.dismiss) private var dismiss

    init(item: TradeItem, onSave: @escaping (TradeItem) -> Void) {
        self.item = item
        self.onSave = onSave
        _selectedImages = State(initialValue: item.images)
    }

    @StateObject private var viewModel = ItemChangeViewModel()
    @EnvironmentObject var coordinator : NavigationCoordinator;

    var body: some View {
        ScrollView {
            //Heading
            Text("New Item")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)

            VStack(alignment: .leading) {

//                Images
//                Preview of the selected Images
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
                TextField("Enter a Title", text: $item.title)
                    .padding(.bottom, 20)

                Text("Description")
                TextEditor(text: $item.description)
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
                    TextField("0", text: $estimatedPriceInput)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                }
                .padding(.bottom, 20)

                // Items user is looking for
                Text("Looking for")
                TextField("Enter items you are looking for", text: $item.preferences)
                    .padding(.bottom, 20)

                // Select if item should be posted to marketplace
                Toggle("Post to Marketplace", isOn: $item.isPostedOnMarketplace)
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
                        if viewModel.isSubmitting {
                            return
                        }
                        viewModel.isSubmitting = true
                        Task {
                            item.estimatedPrice = Double(estimatedPriceInput) ?? 0.0
                            do {
                                try await viewModel.handleSubmit(
                                    toSubmit: item)
                                coordinator.goToItems = true;
                            } catch {
                                viewModel.couldntSubmit = true
                                // TODO notify about error
                            }
                        }
                        viewModel.isSubmitting = false
                        viewModel.shouldNavigateToYourItems = true
                    } label: {
                        Text("Save Item")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        item.title.isEmpty || item.description.isEmpty
                            || viewModel.isSubmitting)
                }
                .padding(.top)
            }
            Button {
                Task {
                    do {
                        try await viewModel.deleteHandler(item);
                        coordinator.goToItems = true;
                    } catch {
                        viewModel.couldntSubmit = true;
                    }
                }
            } label: {
                Text("Delete Item")
                    .font(.title3)
                    .backgroundStyle(.red)
                    .frame(maxWidth: .infinity)
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
    }
}

#Preview {
    ItemChangeView(
        item: TradeItem(
            id: UUID(),
            images: [],
            title: "Test Item",
            description: "A description",
            estimatedPrice: 99.99,
            preferences: "Anything",
            isPostedOnMarketplace: true,
            belongsTo: AppUser(id: UUID(), email: "", displayName: "")
        ),
        onSave: { _ in }
    )
}
