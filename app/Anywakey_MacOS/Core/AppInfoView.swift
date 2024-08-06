
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
        BubbleButton {
            showView = false
        } label: {
            Text("close")
        }

    }
}
