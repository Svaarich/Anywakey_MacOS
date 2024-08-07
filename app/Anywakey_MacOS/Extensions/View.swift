
import SwiftUI

extension View {
    public func buttonify() -> some View {
        modifier(Buttonifier())
    }
    public func animateTransition() -> some View {
        modifier(MenuTransition())
    }
}
