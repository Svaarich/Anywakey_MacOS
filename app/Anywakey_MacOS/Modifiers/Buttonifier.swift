
import SwiftUI

struct Buttonifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(6)
            .padding(.horizontal, 3)
            .background(.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
