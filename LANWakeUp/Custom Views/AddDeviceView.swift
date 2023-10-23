import SwiftUI

struct AddDeviceView: View {
    @FocusState private var focusedTextField: Bool
    
    @State private var isHoverCancel: Bool = false
    @State private var isHoverConfirm: Bool = false
    @State private var isHoverAddButton: Bool = false
    @State private var showSaveAlert: Bool = false
    @State private var newDeviceName: String = "New Device"
    
    private var device: WakeUp.Device
    private var addAction: (WakeUp.Device) -> Void
    
    init(device: WakeUp.Device, addAction: @escaping (WakeUp.Device) -> Void) {
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
                            .opacity(isHoverConfirm ? 1 : 0.6)
                            .foregroundColor(.white)
                            .font(Font.system(size: DrawingConstants.addButtonSize))
                            .onTapGesture {
                                let newDevice = WakeUp.Device(
                                    name: newDeviceName,
                                    MAC: device.MAC,
                                    BroadcastAddr: device.BroadcastAddr,
                                    Port: device.Port
                                )
                                addAction(newDevice)
                                withAnimation {
                                    isHoverAddButton.toggle()
                                    showSaveAlert.toggle()
                                    newDeviceName = "New device"
                                }
                            }
                            .onHover { hover in
                                withAnimation {
                                    isHoverConfirm = hover
                                }
                            }
                        
                        Image(systemName: "xmark.square")
                            .opacity(isHoverCancel ? 1 : 0.6)
                            .foregroundColor(.white)
                            .font(Font.system(size: DrawingConstants.addButtonSize))
                            .onTapGesture {
                                withAnimation {
                                    showSaveAlert.toggle()
                                    focusedTextField.toggle()
                                    newDeviceName = "New device"
                                }
                            }
                            .onHover { hover in
                                withAnimation {
                                    isHoverCancel = hover
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
                showSaveAlert = true
                focusedTextField = true
            }
        }
    }
    
    private struct DrawingConstants {
        static let addButtonSize: CGFloat = 18
        
    }
}
