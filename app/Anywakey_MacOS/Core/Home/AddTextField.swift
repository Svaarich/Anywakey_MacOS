
import SwiftUI

struct AddTextField: View {
    
   
    let prompt: String
    @Binding var text: String
    let isValid: Bool
    
    @FocusState private var isFocused
    
    init(prompt: String, text: Binding<String>, isValid: Bool = true) {
        self.prompt = prompt
        self._text = text
        self.isValid = isValid
    }
    
    var body: some View {
        
        TextField(prompt, text: $text)
        .focused($isFocused)
        .textFieldStyle(.plain)
        .padding(6)
        .padding(.horizontal, 6)
        
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.secondary.opacity(0.1))
                .opacity(isFocused ? 1.0 : 0.6)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(lineWidth: 1)
                        .foregroundStyle(isValid ? Color.secondary : Color.red)
                        .opacity(!isValid ? 1 : (isFocused ? 1 : 0))
                }
        )
        .animation(.smooth(duration: 0.3), value: isFocused)
    }
}
