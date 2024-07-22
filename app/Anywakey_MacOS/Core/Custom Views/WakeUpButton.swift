import SwiftUI

struct WakeUpButton: View {
    
    @State private var isPressed: Bool = false
    @State private var isHover:Bool = false
    
    let device: Device
    
    let wol = WakeOnLAN()
    
    var body: some View {
        VStack {
            button
                .disabled(!isValid())
                .buttonStyle(.plain)
                .scaleEffect(!isValid() ? 1.0 : isHover ? 1.05 : 1.0)
                .onHover { hover in
                    withAnimation {
                        isHover = hover
                    }
                }
        }
    }
    
    private func isValid() -> Bool {
        if !device.BroadcastAddr.isValidAddress() ||
            !device.MAC.isValidMAC() ||
            !device.Port.isValidPort() {
            return false
        }
        return true
    }
    
    private var button: some View {
        Button {
            if isValid() {
                _ = wol.target(device: device)
                print(device)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                    .frame(maxWidth: 500, maxHeight: 250)
                    .opacity(0.2)
                
                RoundedRectangle(cornerRadius: DrawingConstants.buttonCornerRadius)
                    .stroke(lineWidth: DrawingConstants.buttonStrokeWidth)
                    .frame(maxWidth: 500, maxHeight: 250)
                    .opacity(0.8)
                
                Text(isValid() ? "WAKE UP" : "WRONG INPUT")
                    .font(Font.system(size: DrawingConstants.fontSIze))
            }
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

