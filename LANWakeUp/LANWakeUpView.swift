import SwiftUI

struct LANWakeUpView: View {
    @ObservedObject var computer: Computer
    @State private var showSaveAlert = false
    @State private var showDeleteAlert = false
    @State private var isPressed = false
    @State private var isHoverAddButton = false
    @State private var isHoverDeleteButton = false
    @State private var isHoverMenu = false
    
    var body: some View {
        VStack {
            HStack {
                deviceList
                Spacer()
                menuAddDelete
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
    var deviceList: some View {
        ZStack {
            background
                .frame(width: 140, height: 30)
            HStack {
                Image(systemName: "desktopcomputer")
                Text("My devices")
                Picker("", selection: $computer.device) {
                    ForEach(computer.listOfDevices) { pc in
                        if pc.status == .Online {
                            Text(pc.name) + Text(" online").foregroundColor(DrawingConstants.pickerColorOnline)
                        } else if pc.status == .Offline {
                            Text(pc.name) + Text(" offline").foregroundColor(DrawingConstants.pickerColorOffline)
                        } else {
                            Text(pc.name) + Text(" unknown").foregroundColor(DrawingConstants.pickerColorDefault)
                        }
                    }
                }
                .labelsHidden()
                .frame(width: DrawingConstants.deviceListWidth)
                
            }
        }
    }
    
    //MARK: Add and Delete menu
    var menuAddDelete: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.menuAddDeteleCornerRadius)
                    .stroke(lineWidth: 1)
                    .opacity(isHoverMenu ? 0.6 : 0.5)
                RoundedRectangle(cornerRadius: DrawingConstants.menuAddDeteleCornerRadius)
                    .fill()
                    .opacity(isHoverMenu ? 0.3 : 0.1)
            }
            .foregroundColor(.secondary)
            .frame(width: DrawingConstants.menuAddDeteleWidth)
            HStack {
                addButton
                deleteButton
            }
        }
        .scaleEffect(isHoverMenu ? 1.1 : 1.0)
        .onHover { hover in
            withAnimation {
                isHoverMenu = hover
            }
        }
        .padding(.trailing, 2)
    }
    
    //MARK: Add device button
    var addButton: some View {
        Button {
            computer.device.name = "New Device"
            computer.device.status = .Default
            showSaveAlert.toggle()
        } label: {
            Image(systemName: isHoverAddButton ? "plus.rectangle.fill" : "plus.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: DrawingConstants.addDeleteButtonWidth)
                .foregroundColor(.white)
        }
        .newAndOldAlert(isPresented: $showSaveAlert, text: $computer.device.name) {
            computer.add(newDevice: computer.device)
        }
        .buttonStyle(.borderless)
        .opacity(isHoverAddButton ? DrawingConstants.hoverAddDeleteButtonOpacity : DrawingConstants.defaultAddDeleteButtonOpacity)
        .onHover { hover in
            withAnimation {
                isHoverAddButton = hover
            }
        }
    }
    
    //MARK: Delete selected device button
    var deleteButton: some View {
        Button {
            for pc in computer.listOfDevices {
                if computer.device == pc {
                    showDeleteAlert.toggle()
                }
            }
        } label: {
            Image(systemName: isHoverDeleteButton ? "minus.rectangle.fill" : "minus.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: DrawingConstants.addDeleteButtonWidth)
                .foregroundColor(.white)
        }
        .alert("Delete device?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
                .keyboardShortcut(.cancelAction)
            Button("OK") {
                computer.delete(oldDevice: computer.device)
                computer.device.BroadcastAddr = ""
                computer.device.MAC = ""
                computer.device.Port = ""
            }
            .keyboardShortcut(.defaultAction)
        }
        .opacity(isHoverDeleteButton ? DrawingConstants.hoverAddDeleteButtonOpacity : DrawingConstants.defaultAddDeleteButtonOpacity)
        .buttonStyle(.borderless)
        .onHover { hover in
            withAnimation {
                isHoverDeleteButton = hover
            }
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
            Circle()
                .fill()
                .frame(width: DrawingConstants.statusDiameter)
                .padding(.trailing, 5)
                .foregroundColor(getStatusColor())
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
    
    var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 1)
                .foregroundColor(.secondary)
                .opacity(0.5)
            RoundedRectangle(cornerRadius: 7)
                .fill()
                .foregroundColor(.secondary)
                .opacity(0.1)
        }
    }
    
    //MARK: DrawingConstants
    private struct DrawingConstants {
        
        static let deviceListWidth: CGFloat = 20
        static let clearButtonOpacity: CGFloat = 0.5
        
        static let statusDiameter: CGFloat = 12
        static let statusColorOnline: Color = .green
        static let statusColorOffline: Color = .red
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
