import SwiftUI

struct LANWakeUpView: View {
    @ObservedObject var computer: Computer
    
    @State private var newDeviceName = "New device"
    
    @State private var showSaveAlert = false
    @State private var showDeleteAlert = false
    
    @State private var isPressed = false
    @State private var isPresentedPopOver = false
    
    @State private var isHoverAddButton = false
    @State private var isHoverDeleteButton = false
    @State private var isHoverMyDevices = false
    @State private var hoverDevice = WakeUp.Device(MAC: "",
                                                   BroadcastAddr: "",
                                                   Port: "")
    
    var body: some View {
        VStack {
            HStack {
                deviceListButton
                Spacer()
                addNewDeviceButton
            }
            .padding(.bottom)
            addressField
            macField
            portField
            wakeUpButton
        }
        .padding([.horizontal, .bottom])
        .padding(.top, 8)
        .background(BlurredEffect().ignoresSafeArea())
        .onChange(of: computer.listOfDevices) { _ in
            computer.updateStatusList()
        }
        .onChange(of: computer.device.BroadcastAddr) { _ in
            withAnimation {
                computer.onlineStatus = .Default
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    computer.currentDeviceStatus()
                }
            }
        }
        .onAppear {
            computer.fetchUserDefaults()
            if let device = computer.listOfDevices.first {
                computer.device = device
            }
            computer.updateStatusList()
        }
    }
    
    private func getStatusColor() -> Color {
        switch computer.onlineStatus {
        case .Online:
            return DrawingConstants.statusColorOnline
        case .Offline:
            return DrawingConstants.statusColorOffline
        case .Default:
            return DrawingConstants.statusColorDefault
        }
    }
    
    //MARK: List of saved devices
    var deviceListButton: some View {
        ZStack {
            deviceListBackground
                .frame(width: 115, height: 30)
            HStack {
                Image(systemName: "desktopcomputer")
                Text("My devices")
            }
        }
        .scaleEffect(isPresentedPopOver ? 1.1 : 1)
        .onHover { hover in
            withAnimation {
                isHoverMyDevices = hover
                isPresentedPopOver = true
            }
        }
        .popover(isPresented: $isPresentedPopOver,
                 attachmentAnchor: .point(.bottom),
                 arrowEdge: .bottom) {
            VStack {
                ForEach(computer.listOfDevices) { pc in
                    var isHover: Bool {
                        pc == hoverDevice
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .foregroundColor(.white)
                            .opacity(isHover ? 0.2 : 0.1)
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.white)
                            .opacity(isHover ? 0.5 : 0.3)
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(pc == computer.device ? 1 : 0)
                            if pc.status == .Online {
                                HStack {
                                    Text(pc.name)
                                    Spacer()
                                    Text("online")
                                        .foregroundColor(DrawingConstants.onlineColor)
                                }
                            } else {
                                HStack {
                                    Text(pc.name)
                                    Spacer()
                                    Text("offline")
                                        .foregroundColor(DrawingConstants.offlineColor)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                    }
                    .onHover { _ in
                        hoverDevice = pc
                    }
                    .onTapGesture {
                        withAnimation {
                            computer.device = pc
                            isPresentedPopOver = false
                        }
                    }
                }
                Divider()
                HStack {
//                    Spacer()
                    deleteButton
                        .onTapGesture {
//                            isPresentedPopOver = false
                        }
                }
                
            }
            .frame(width: 140)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .onAppear {
                hoverDevice = computer.device
            }
        }
    }

    //MARK: Add Button
    var addNewDeviceButton: some View {
        AddDeviceView(isHoverAddButton: isHoverAddButton,
                  showSaveAlert: showSaveAlert,
                  newDeviceName: newDeviceName,
                  device: computer.device) { device in
            computer.add(newDevice: device)
        }
    }
    
    //MARK: Delete Button
    var deleteButton: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill()
                    .foregroundColor(isHoverDeleteButton ? .pink : .white)
                    .opacity(isHoverDeleteButton ? 0.3 : 0.1)
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(isHoverDeleteButton ? .pink : .white)
                    .opacity(isHoverDeleteButton ? 0.6 : 0.5)
            }
            Button {
                for pc in computer.listOfDevices {
                    if computer.device.BroadcastAddr == pc.BroadcastAddr
                        && computer.device.MAC == pc.MAC
                        && computer.device.Port == pc.Port
                        && computer.device.name == pc.name
                    {
                        computer.delete(oldDevice: computer.device)
                        if let device = computer.listOfDevices.first {
                            computer.device = device
                        }
                        isPresentedPopOver.toggle()
                    }
                }
            } label: {
                Text("Delete ")
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderless)
            .padding(.vertical, 4)
        }
        .onHover { hover in
            isHoverDeleteButton.toggle()
        }
    }
    
    //MARK: Textfields
    var addressField: some View {
        ZStack {
            VStack {
                HStack {
                    Text(" IP / Broadcast Address:")
                    Spacer()
                    status
                }
                TextField("Enter IP / Broadcast Address...", text: $computer.device.BroadcastAddr)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text(" IPv4(e.g. 192.168.0.123) or DNS name for the host.")
                        .font(Font.system(size: DrawingConstants.instructionTextSize))
                        .foregroundStyle(DrawingConstants.instructionTextColor)
                        .opacity(DrawingConstants.instructionTextOpacity)
                    Spacer()
                }
                .padding(.bottom, 8)
            }
        }
    }
    
    var macField: some View {
        VStack {
            HStack {
                Text(" MAC Address:")
                Spacer()
            }
            TextField("Enter MAC address...", text: Binding(
                get: { computer.device.MAC.uppercased() },
                set: { newValue in computer.device.MAC = newValue.uppercased() })
            )
            .textFieldStyle(.roundedBorder)
            HStack {
                Text(" (e.g. 00:11:22:AA:BB:CC)")
                    .font(Font.system(size: DrawingConstants.instructionTextSize))
                    .foregroundStyle(DrawingConstants.instructionTextColor)
                    .opacity(DrawingConstants.instructionTextOpacity)
                Spacer()
            }
            .padding(.bottom, 8)
        }
    }
    
    var portField: some View {
        VStack {
            HStack{
                Text(" Port:")
                Spacer()
            }
            TextField("Enter port...", text: Binding(
                get: {
                    computer.device.Port
                },
                set: { newValue in
                    if let newUInt16 = UInt16(newValue) {
                        computer.device.Port = String(newUInt16)
                    } else if newValue.isEmpty {
                        computer.device.Port = newValue
                    }
                })
                      
            )
            .textFieldStyle(.roundedBorder)
            HStack {
                Text(" Typically sent to port 7 or 9")
                    .font(Font.system(size: DrawingConstants.instructionTextSize))
                    .foregroundStyle(DrawingConstants.instructionTextColor)
                    .opacity(DrawingConstants.instructionTextOpacity)
                Spacer()
                clearButton
            }
        }
    }
    
    //MARK: Status indicator
    var status: some View {
        HStack {
            Text("Status:")
                .foregroundColor(DrawingConstants.statusTextColor)
                .opacity(DrawingConstants.statusTextOpacity)
            ZStack {
                Circle()
                    .strokeBorder(lineWidth: 1)
                    .foregroundColor(getStatusColor())
                Circle()
                    .fill()
                    .foregroundColor(getStatusColor())
                    .opacity(0.1)
            }
            .frame(width: DrawingConstants.statusDiameter)
            .padding(.trailing, 5)
        }
    }
    
    //MARK: Clear button
    var clearButton: some View {
        HStack {
            if computer.device.BroadcastAddr.isEmpty && computer.device.MAC.isEmpty && computer.device.Port.isEmpty {
                Button("Clear All") {
                }
                .opacity(DrawingConstants.clearButtonOpacity)
            } else {
                Button("Clear All") {
                    computer.device.BroadcastAddr = ""
                    computer.device.MAC = ""
                    computer.device.Port = ""
                }
            }
        }
        .buttonStyle(.borderless)
        .padding(.trailing, 2)
    }
    
    //MARK: WakeUp button
    var wakeUpButton: some View {
        let wakeUpButton = WakeUpButton(device: computer.device, isPressed: isPressed) {
            computer.target(device: computer.device)
        }
            .padding(.vertical, 8)
        return wakeUpButton
    }
    
    var deviceListBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 1)
                .opacity(isPresentedPopOver ? 0.6 : 0.5)
            RoundedRectangle(cornerRadius: 7)
                .fill()
                .opacity(isPresentedPopOver ? 0.3 : 0.1)
        }
        .foregroundColor(.secondary)
    }
    
    //MARK: DrawingConstants
    private struct DrawingConstants {
        
        static let deviceListWidth: CGFloat = 20
        static let clearButtonOpacity: CGFloat = 0.5
        
        static let statusDiameter: CGFloat = 12
        static let statusColorOnline: Color = .green
        static let statusColorOffline: Color = .pink
        static let statusColorDefault: Color = .white.opacity(0.5)
        
        static let statusTextOpacity: CGFloat = 0.6
        static let statusTextColor: Color = .white
        
        static let onlineColor: Color = .green
        static let offlineColor: Color = .secondary
        
        static let instructionTextSize: CGFloat = 11
        static let instructionTextOpacity: CGFloat = 0.5
        static let instructionTextColor: Color = .white
        
        static let addButtonColor: Color = .secondary
        static let addButtonSize: CGFloat = 18
        
        static let menuAddDeteleWidth: CGFloat = 65
        static let menuAddDeteleCornerRadius: CGFloat = 7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let computer = Computer()
        LANWakeUpView(computer: computer)
            .frame(width: 380)
    }
}
