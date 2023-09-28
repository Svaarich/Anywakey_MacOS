import SwiftUI

struct LANWakeUpView: View {
    @ObservedObject var computer: Computer
    @State private var showSaveAlert = false
    @State private var showDeleteAlert = false
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            HStack {
                deviceList
                Spacer()
                addButton
                deleteButton
            }
            .padding(.vertical)
            addressField
            macField
            portField
            clearButton
            wakeUpButton
        }
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
        .padding()
        .background(BlurredEffect())
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
    
    //MARK: Add device button
    var addButton: some View {
        Button("Add") {
            computer.device.name = "New Device"
            computer.device.status = .Default
            showSaveAlert.toggle()
        }
        .buttonStyle(.borderedProminent)
        .newAndOldAlert(isPresented: $showSaveAlert, text: $computer.device.name) {
            computer.add(newDevice: computer.device)
        }
    }
    
    //MARK: Delete selected device button
    var deleteButton: some View {
        Button("Delete") {
            for pc in computer.listOfDevices {
                if computer.device == pc {
                    showDeleteAlert.toggle()
                }
            }
        }
        .buttonStyle(.bordered)
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
    }
    
    //MARK: Textfields
    var addressField: some View {
        VStack {
            HStack {
                Text(" IP / Broadcast Address:")
                Spacer()
                status
            }
            
            TextField("IP address: XXX.XXX.XXX.XXX", text: $computer.device.BroadcastAddr)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
        }
    }

    var macField: some View {
        VStack {
            HStack {
                Text(" MAC Address:")
                Spacer()
            }
            TextField("MAC address: XX:XX:XX:XX:XX:XX", text: Binding(
                get: { computer.device.MAC.uppercased() },
                set: { newValue in computer.device.MAC = newValue.uppercased() })
            )
            .textFieldStyle(.roundedBorder)
            .padding(.bottom)
        }
    }

    var portField: some View {
        VStack {
            HStack{
                Text(" Port:")
                Spacer()
            }
            TextField("Port: XXXXX (9 - Default)", text: Binding(
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
        }
    }
    
    //MARK: Status indicator
    var status: some View {
        HStack {
            Text("Status:")
                .foregroundColor(.gray)
                .opacity(0.6)
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
                Button(" Clear All") {
                }
                .buttonStyle(.borderless)
                .opacity(DrawingConstants.clearButtonOpacity)
            } else {
                Button(" Clear All") {
                    computer.device.BroadcastAddr = ""
                    computer.device.MAC = ""
                    computer.device.Port = ""
                }
                .buttonStyle(.borderless)
            }
            Spacer()
        }
    }
    
    //MARK: WakeUp button
    var wakeUpButton: some View {
        let wakeUpButton = WakeUpButton(device: computer.device, isPressed: isPressed) {
            computer.target(device: computer.device)
        }
            .padding(.vertical, 8)
        return wakeUpButton
    }
    
    //MARK: DrawingConstants
    private struct DrawingConstants {
        
        static let statusDiameter: CGFloat = 12
        static let deviceListWidth: CGFloat = 20
        static let clearButtonOpacity: CGFloat = 0.5
        
        static let statusColorOnline: Color = .green
        static let statusColorOffline: Color = .red
        static let statusColorDefault: Color = .gray.opacity(0.5)
        
        static let pickerColorOnline: Color = .green
        static let pickerColorOffline: Color = .secondary
        static let pickerColorDefault: Color = .pink
        
        static let instructionTextSize: CGFloat = 11
        static let instructionTextOpasity: CGFloat = 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let computer = Computer()
        LANWakeUpView(computer: computer)
    }
}
