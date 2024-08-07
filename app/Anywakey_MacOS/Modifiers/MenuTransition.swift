import SwiftUI

struct MenuTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .move(edge: .leading),
                removal: .opacity)
                .combined(with: .opacity))
    }
}
