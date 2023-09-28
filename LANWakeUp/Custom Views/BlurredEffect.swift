// Blurred View maker

import SwiftUI

struct BlurredEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = NSVisualEffectView()
        view.material = .fullScreenUI
        view.blendingMode = .behindWindow
        return view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

