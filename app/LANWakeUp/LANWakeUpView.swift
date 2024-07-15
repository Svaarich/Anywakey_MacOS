import SwiftUI

struct LANWakeUpView: View {
    @ObservedObject var computer: Computer
    
    @State private var isPresentedListOfDevices = false
    @State private var isHoverDeleteButton = false
    
    var body: some View {
        VStack {
            HStack {
                deviceListView
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
                computer.device.status = .Default
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    computer.currentDeviceStatus()
                }
            }
        }
        .onAppear {
            computer.fetchUserDefaults()
            computer.updateStatusList()
            if let device = computer.listOfDevices.first {
                computer.device = device
            }
        }
    }
    
    private func getStatusColor() -> Color {
        switch computer.device.status {
        case .Online:
            return DrawingConstants.statusColorOnline
        case .Offline:
            return DrawingConstants.statusColorOffline
        case .Default:
            return DrawingConstants.statusColorDefault
        }
    }
    
    //MARK: List of saved devices
    var deviceListView: some View {
            DeviceList(listOfDevices: computer.listOfDevices,
                       currentDevice: computer.device,
                       computer: computer)
    }
    
    //MARK: Add Button
    var addNewDeviceButton: some View {
        AddDeviceView(device: computer.device) { device in
            computer.add(newDevice: device)
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
        let wakeUpButton = WakeUpButton(device: computer.device) {
            computer.target(device: computer.device)
        }
            .padding(.vertical, 8)
        return wakeUpButton
    }
    
    var deviceListBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 1)
                .opacity(isPresentedListOfDevices ? 0.6 : 0.5)
            RoundedRectangle(cornerRadius: 7)
                .fill()
                .opacity(isPresentedListOfDevices ? 0.3 : 0.1)
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
