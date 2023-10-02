import SwiftUI

struct AddButton: View {
    
    @State private var isHoverAddButton: Bool
    @State private var showSaveAlert: Bool
    @State private var newDeviceName: String
    @FocusState private var focusedTextField: Bool
    private var device: WakeUp.Device
    private var addAction: (WakeUp.Device) -> Void
    
    init(isHoverAddButton: Bool, showSaveAlert: Bool, newDeviceName: String, device: WakeUp.Device, addAction: @escaping (WakeUp.Device) -> Void) {
        self.isHoverAddButton = isHoverAddButton
        self.showSaveAlert = showSaveAlert
        self.newDeviceName = newDeviceName
        self.device = device
        self.addAction = addAction
    }

    var body: some View {
        ZStack {
            ZStack(alignment: .trailing)  {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 1)
                    .opacity(isHoverAddButton ? 0.6 : 0.5)
                RoundedRectangle(cornerRadius: 7)
                    .fill()
                    .opacity(isHoverAddButton ? 0.3 : 0.1)
            }
            .frame(width:showSaveAlert ? 180 : 31)
            HStack {
                TextField("Enter name...", text: $newDeviceName)
                    .labelsHidden()
                    .frame(width: showSaveAlert ? 112 : 0)
                    .foregroundColor(.white)
                    .textFieldStyle(.roundedBorder)
                    .opacity(showSaveAlert ? 1 : 0)
                    .focused($focusedTextField)
                if showSaveAlert {
                    HStack {
                        Image(systemName: "checkmark.square")
                            .foregroundColor(.white)
                            .font(Font.system(size: DrawingConstants.addButtonSize))
                            .onTapGesture {
                                addAction(WakeUp.Device(name: newDeviceName,
                                                        MAC: device.Port,
                                                        BroadcastAddr: device.BroadcastAddr,
                                                        Port: device.Port))
                                print("im new button and i add: \(device)")
                                withAnimation {
                                    showSaveAlert.toggle()
                                    newDeviceName = "New device"
                                }
                            }
                        
                        Image(systemName: "xmark.square")
                            .foregroundColor(.white)
                            .font(Font.system(size: DrawingConstants.addButtonSize))
                            .onTapGesture {
                                withAnimation {
                                    showSaveAlert.toggle()
                                    newDeviceName = "New device"
                                }
                            }
                    }
                }
                else {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(Font.system(size: DrawingConstants.addButtonSize))
                        .opacity(isHoverAddButton ? 1 : 0.8)
                }
            }
            .padding(.trailing, showSaveAlert ? 0 : 7)
        }
        .foregroundColor(.secondary)
        .frame(alignment: .leading)
        .padding(.trailing, 2)
        .onHover { hover in
            withAnimation {
                isHoverAddButton = hover
            }
        }
        .onTapGesture {
            withAnimation {
                showSaveAlert.toggle()
                focusedTextField = false
            }
        }
    }
    
    private struct DrawingConstants {
        static let addButtonSize: CGFloat = 18
        
    }
}
