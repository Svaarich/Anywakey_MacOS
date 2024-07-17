import SwiftUI

struct WakeUpButton: View {
    
    @State private var isPressed: Bool = false
    @State private var isHover:Bool = false
    
    let device: Device
    
    var body: some View {
        VStack {
            // Inactive button if 1 of TextFields is empty
            if dataService.displayedDevice.BroadcastAddr.isEmpty || dataService.displayedDevice.MAC.count != 17 || dataService.displayedDevice.Port.isEmpty {
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
                        _ = wol.target(device: dataService.displayedDevice)
                    }
                    .pressEvents { // Custom pressEvent modifier -> ButtonPressModifier
                        withAnimation(.easeInOut(duration: DrawingConstants.animationDuration)) {
                            isPressed = true
    
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

