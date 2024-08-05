
import SwiftUI

struct AppInfoView: View {
    
    @Binding var showView: Bool
    
    @State private var hoverClose: Bool = false
    
    var body: some View {
        VStack {
            Text("App info view")
            Spacer()
            HStack {
                Spacer()
                dismissButton
            }
        }
        .padding(8)
        .frame(width: 200)
    }
    
    private var dismissButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showView = false
            }
        } label: {
//            Image(systemName: "xmark")
            Text("close")
                .foregroundStyle(hoverClose ? .white : .secondary)
                .padding(.horizontal, 8)
                .frame(height: 20)
                .background(Color.gray.opacity(hoverClose ? 0.4 : 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverClose ? 1.1 : 1.0)
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverClose = hover
            }
        }
    }
}
