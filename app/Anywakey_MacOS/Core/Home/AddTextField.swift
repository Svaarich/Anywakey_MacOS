
import SwiftUI

struct AddTextField: View {
    
    let prompt: String
    @Binding var text: String
    
    @FocusState private var isFocused
    
    var body: some View {
        
        TextField(prompt, text: $text)
        .focused($isFocused)
        .textFieldStyle(.plain)
        .padding(6)
        .padding(.horizontal, 6)
        
        .background(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(lineWidth: isFocused ? 1.5 : 1)
                .foregroundStyle(Color.secondary.opacity(isFocused ? 1.0 : 0.6))
                .animation(.smooth(duration: 0.3), value: isFocused)
        )
    }
}
