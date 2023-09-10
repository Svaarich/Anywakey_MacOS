import SwiftUI

extension View {
    // CustomAlert
    func newAndOldAlert(isPresented: Binding<Bool>, text: Binding<String>, addDevice: @escaping () -> Void) -> some View {
        if #available(macOS 13.0, *) {
            return alert("Enter device name", isPresented: isPresented) {
                TextField("Enter device name", text: text)
                Button("Cancel", role: .cancel) { }
                    .keyboardShortcut(.defaultAction)
                Button("OK") {
                    addDevice()
                }
                .keyboardShortcut(.cancelAction)
            }
        } else {
            return sheet(isPresented: isPresented) {
                CustomAlert(prompt: "Enter device name", value: text) {
                    addDevice()
                }
            }
        }
    }
    
    
    // Custom buttonPressed tracker
    func pressEvents(onPress: @escaping(() -> Void), onRelease: @escaping(() -> Void)) -> some View {
        modifier(ButtonPressModifier(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}


