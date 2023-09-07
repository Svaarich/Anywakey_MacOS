
//MARK: Custom buttonPressed tracker

import Foundation
import SwiftUI

struct ButtonPressModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({_ in
                    onPress()
                })
                .onEnded({_ in
                    onRelease()
                })
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping(() -> Void), onRelease: @escaping(() -> Void)) -> some View {
        modifier(ButtonPressModifier(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}

