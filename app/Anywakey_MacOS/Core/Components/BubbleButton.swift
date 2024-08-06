
import SwiftUI

struct BubbleButton: View {
    
    @State private var isHover: Bool = false
    
    let label: any View
    let action: () -> ()
    
    init(action: @escaping () -> (), label: @escaping () -> any View) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                action()
            }
        } label: {
            AnyView(self.label)
                .foregroundStyle(isHover ? .white : .secondary)
                .frame(height: 20)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(isHover ? 0.4 : 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(isHover ? 1.1 : 1.0)
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                isHover = hover
            }
        }
    }
}
