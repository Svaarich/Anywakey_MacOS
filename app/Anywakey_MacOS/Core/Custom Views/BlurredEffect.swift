// Blurred View maker

import SwiftUI

struct BlurredEffect: NSViewRepresentable {
    
    let material: NSVisualEffectView.Material
    
    init(_ material: NSVisualEffectView.Material) {
        self.material = material
    }
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        return view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

