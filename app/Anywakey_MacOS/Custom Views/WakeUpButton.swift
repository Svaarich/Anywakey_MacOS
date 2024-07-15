import SwiftUI

struct WakeUpButton: View {
    @State private var isPressed: Bool = false
    @State private var isHover:Bool = false
    private var device: WakeUp.Device
    private var action: () -> Error?
    
    init(device: WakeUp.Device, action: @escaping () -> Error?) {
        self.device = device
        self.action = action
    }
    
    var body: some View {
        VStack {
            // Inactive button if 1 of TextFields is empty
            if device.BroadcastAddr.isEmpty || device.MAC.count != 17 || device.Port.isEmpty {
                button
                    .opacity(DrawingConstants.opacityInactiveButton)
            } else {
                // Active button
                button
                    .scaleEffect(isHover ? 1.05 : 1)
                    .scaleEffect(isPressed ? DrawingConstants.scaleEffectPressedButton : DrawingConstants.scaleEffectDefault)
                    .onHover { hover in
                        withAnimation {
                            isHover = hover
                        }
                    }
                    .onTapGesture {
                        _ = action()
                    }
                    .pressEvents { // Custom pressEvent modifier -> ButtonPressModifier
                        withAnimation(.easeInOut(duration: DrawingConstants.animationDuration)) {
                            isPressed = true
                        }
                    } onRelease: {
                        withAnimation {
                            isPressed = false
                        }
                            
                    }
            }
        }
    }
    
    var button: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                .frame(width: DrawingConstants.buttonWidth, height: DrawingConstants.buttonHeigh)
                .opacity(isHover ? 0.2 : 0.1)
            RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                .stroke(lineWidth: DrawingConstants.buttonStrokeWidth)
                .frame(width: DrawingConstants.buttonWidth, height: DrawingConstants.buttonHeigh)
                .opacity(isHover ? 0.8 : 0.6)
            Text("WAKE UP")
                .font(Font.system(size: DrawingConstants.fontSIze))
                .opacity(isHover ? DrawingConstants.opacityActiveButton : 0.8)
        }
    }
    
    private struct DrawingConstants {
        
        // Wake UP Button font size
        static let fontSIze: CGFloat = 25
        
        // Wake Up Button settings
        static let buttonCornerRadius: CGFloat = 15
        static let buttonHeigh: CGFloat = 60
        static let buttonWidth: CGFloat = 150
        static let buttonStrokeWidth: CGFloat = 1.5
        
        // Scale effects
        static let scaleEffectPressedButton: CGFloat = 0.9
        static let scaleEffectDefault: CGFloat = 1.0
        
        // Opacities
        static let buttonBackgroundOpacity: CGFloat = 0.2
        
        static let opacityInactiveButton: CGFloat = 0.5
        static let opacityActiveButton: CGFloat = 1
        
        // Color settings
        static let colorInactiveButton: Color = .gray
        static let colorActiveButton: Color = .white
        
        // Animation
        static let animationDuration: CGFloat = 0.2
    }
}

