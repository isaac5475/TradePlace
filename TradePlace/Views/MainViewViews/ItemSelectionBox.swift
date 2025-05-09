
import SwiftUI

struct ItemSelectionBox: View {
    let item: TradeItem
    let isSelected: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            VStack(spacing: 8) {
                Rectangle()
                    .fill(isSelected ? Color.green.opacity(0.6) : Color.gray.opacity(0.3))
                    .frame(height: 100)
                    .overlay(
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(isSelected ? .green : .blue)
                    )

                Text(item.title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}
