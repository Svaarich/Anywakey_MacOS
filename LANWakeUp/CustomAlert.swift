import SwiftUI

struct CustomAlert: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var value: String
    var prompt: String = ""
    var action: () -> Void
    @State var fieldValue: String
    
    init(prompt: String, value: Binding<String>, action: @escaping () -> Void) {
        self.prompt = prompt
        _value = value
        _fieldValue = State<String>(initialValue: value.wrappedValue)
        self.action = action
    }
    
    var body: some View {
        VStack {
            alertImage
            Spacer()
            text
            textField
            HStack {
                cancelButton
                okButton
            }
        }
        .padding()
    }
    
    var alertImage: some View {
        Image("alertImage")
            .padding(.bottom, 10)
    }
    
    var text: some View {
        Text(prompt)
            .font(Font.headline.weight(.bold))
    }
    
    var textField: some View {
        TextField("Device name...", text: $fieldValue)
            .padding(.top, 7)
            .padding(.bottom)
    }
    var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
                .frame(width: DrawingConstants.buttonWidth)
        }
        .controlSize(.large)
        .keyboardShortcut(.cancelAction)
    }
    
    var okButton: some View {
        Button {
            value = fieldValue
            action()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("OK")
                .frame(width: DrawingConstants.buttonWidth)
        }
        .controlSize(.large)
        .keyboardShortcut(.defaultAction)
    }
    
    struct DrawingConstants {
        static let buttonWidth: CGFloat = 95
    }
}

