import SwiftUI

struct WakeUpButton: View {
    @State private var isPressed: Bool
    private var device: WakeUp.Device
    private var action: () -> Error?
    
    init(device: WakeUp.Device, isPressed: Bool, action: @escaping () -> Error?) {
        self.device = device
        self.isPressed = isPressed
        self.action = action
    }
    
    var body: some View {
        VStack {
            // Inactive button if 1 of TextFields is empty
            if device.BroadcastAddr.isEmpty || device.MAC.count != 17 || device.Port.isEmpty {
                button
                    .opacity(DrawingConstants.opacityInactiveButton)
                    .foregroundColor(DrawingConstants.colorInactiveButton)
                
            } else {
                // Active button
                button
                    .foregroundColor(DrawingConstants.colorActiveButton)
                    .opacity(isPressed ? DrawingConstants.opacityPressedButton : DrawingConstants.opacityActiveButton)
                    .scaleEffect(isPressed ? DrawingConstants.scaleEffectPressedButton : DrawingConstants.scaleEffectDefauld)
                    .onTapGesture {
                        _ = action()
                    }
                // Custom pressEvent modifier -> ButtonPressModifier
                    .pressEvents {
                        withAnimation(.easeInOut(duration: DrawingConstants.animationDuration)) {
                            isPressed = true
                        }
                    } onRelease: {
                        isPressed = false
                    }
            }
            
        }
    }
    
    var button: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                .frame(width: DrawingConstants.buttonWidth, height: DrawingConstants.buttonHeigh)
                .opacity(DrawingConstants.buttonBackgroundOpacity)
            RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                .stroke(lineWidth: DrawingConstants.buttonStrokeWidth)
                .frame(width: DrawingConstants.buttonWidth, height: DrawingConstants.buttonHeigh)
            Text("WAKE UP")
                .font(Font.system(size: DrawingConstants.fontSIze))
        }
    }
    
    private struct DrawingConstants {
        
        // Wake UP Button font size
        static let fontSIze: CGFloat = 25
        
        // Wake Up Button settings
        static let buttonCornerRadius: CGFloat = 20
        static let buttonHeigh: CGFloat = 60
        static let buttonWidth: CGFloat = 150
        static let buttonStrokeWidth: CGFloat = 2
        
        // Scale effects
        static let scaleEffectPressedButton: CGFloat = 1.15
        static let scaleEffectDefauld: CGFloat = 1.0
        
        // Opasities
        static let buttonBackgroundOpacity: CGFloat = 0.001
        static let opacityPressedButton: CGFloat = 0.5
        static let opacityInactiveButton: CGFloat = 0.5
        static let opacityActiveButton: CGFloat = 1.0
        
        // Color settings
        static let colorInactiveButton: Color = .gray
        static let colorActiveButton: Color = .mint
        
        // Animation
        static let animationDuration: CGFloat = 0.2
    }
}

