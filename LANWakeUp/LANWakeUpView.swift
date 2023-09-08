import SwiftUI

struct LANWakeUpView: View {
    @ObservedObject var computer: Computer
    @State private var showSaveAlert = false
    @State private var showDeleteAlert = false
    @State private var isPressed = false
    
    var body: some View {
        let wakeUpButton = WakeUpButton(device: computer.device, isPressed: isPressed) {
            computer.target(device: computer.device)
        }
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
            wakeUpButton
        }
        .padding()
        .background(BlurredEffect())
        .onAppear {
            computer.fetchUserDefaults()
            if let device = computer.listOfDevices.first {
                computer.device = device
            }
        }
    }
    
    //MARK: List of saved devices
    var deviceList: some View {
        HStack {
            Image(systemName: "desktopcomputer")
            Text("My devices")
            Picker("", selection: $computer.device) {
                ForEach(computer.listOfDevices) { pc in
                    Text(pc.name)
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
            showSaveAlert.toggle()
        }
        .buttonStyle(.borderedProminent)
        .alert("Enter device name", isPresented: $showSaveAlert) {
            TextField("Enter device name", text: $computer.device.name)
            Button("Cancel", role: .cancel) { }
                .keyboardShortcut(.defaultAction)
            Button("OK") {
                computer.add(newDevice: computer.device)
                computer.saveUserDefaults()
            }
            .keyboardShortcut(.cancelAction)
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
                Text("IP / Broadcast Address:")
                Spacer()
            }
            TextField("IP address: XXX.XXX.XXX.XXX", text: $computer.device.BroadcastAddr)
                .padding(.bottom)
        }
    }

    var macField: some View {
        VStack {
            HStack {
                Text("MAC Address:")
                Spacer()
            }
            TextField("MAC address: XX:XX:XX:XX:XX:XX", text: Binding(
                get: { computer.device.MAC.uppercased() },
                set: { newValue in computer.device.MAC = newValue.uppercased() })
            )
            .padding(.bottom)
        }
    }

    var portField: some View {
        VStack {
            HStack{
                Text("Port:")
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
        }
    }
    
    private struct DrawingConstants {
        static let deviceListWidth: CGFloat = 20
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let computer = Computer()
        LANWakeUpView(computer: computer)
    }
}

