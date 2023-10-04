import SwiftUI

extension View {
    // Custom buttonPressed tracker
    func pressEvents(onPress: @escaping(() -> Void), onRelease: @escaping(() -> Void)) -> some View {
        modifier(ButtonPressModifier(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}


