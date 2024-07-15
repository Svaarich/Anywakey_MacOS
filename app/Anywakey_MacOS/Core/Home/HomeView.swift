import SwiftUI

struct HomeView: View {
    @ObservedObject var dataService: DeviceDataService
    
    @State private var isPresentedListOfDevices = false
    @State private var isHoverDeleteButton = false
    
    @State private var name: String = ""
    @State private var mac: String = ""
    @State private var address: String = ""
    @State private var port: String = ""
    
    @State private var currentDevice: Device = Device(
        name: "", MAC: "",
        BroadcastAddr: "", Port: "")
    
    var body: some View {
        VStack {
            HStack {
                deviceListView
                Spacer()
                addDeviceButton
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
//        .onChange(of: dataService.listOfDevices) { _ in
//            dataService.updateStatusList()
//        }
//        .onChange(of: dataService.device.BroadcastAddr) { _ in
//            withAnimation {
//                dataService.device.status = .Default
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    dataService.currentDeviceStatus()
//                }
//            }
//        }
//        .onAppear {
//            dataService.fetchUserDefaults()
//            dataService.updateStatusList()
//            if let device = dataService.listOfDevices.first {
//                dataService.device = device
//            }
//        }
    }
    
//    private func getStatusColor() -> Color {
//        switch dataService.device.status {
//        case .Online:
//            return DrawingConstants.statusColorOnline
//        case .Offline:
//            return DrawingConstants.statusColorOffline
//        case .Default:
//            return DrawingConstants.statusColorDefault
//        }
//    }
    
    //MARK: List of saved devices
    var deviceListView: some View {
        DeviceList()
    }
    
    //MARK: Add Button
    var addDeviceButton: some View {
        AddDeviceView()
    }
    
    //MARK: Textfields
    var addressField: some View {
        ZStack {
            VStack {
                HStack {
                    Text(" IP / Broadcast Address:")
                    Spacer()
//                    status
                }
                TextField("Enter IP / Broadcast Address...", text: $address)
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
            TextField("Enter MAC address...", text: $mac)
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
            TextField("Enter port...", text: $port)
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
            if dataService.displayedDevice.BroadcastAddr.isEmpty && dataService.displayedDevice.MAC.isEmpty && dataService.displayedDevice.Port.isEmpty {
                Button("Clear All") {
                }
                .opacity(DrawingConstants.clearButtonOpacity)
            } else {
                Button("Clear All") {
                    dataService.displayedDevice = Device(name: "", MAC: "", BroadcastAddr: "", Port: "")
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
        HomeView(computer: computer)
            .frame(width: 380)
    }
}
