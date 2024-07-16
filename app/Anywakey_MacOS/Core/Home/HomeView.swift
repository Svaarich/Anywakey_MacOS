
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    @State private var isPresentedListOfDevices = false
    @State private var isHoverDeleteButton = false
    
    @State private var name: String = ""
    @State private var mac: String = ""
    @State private var address: String = ""
    @State private var port: String = ""
    
    @State private var selectedDevice: Device?
    
    var body: some View {
        HStack {
            List(dataService.allDevices, selection: $selectedDevice) { device in
                Text("Select \(device.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6)
                    .padding(.horizontal, 6)
                    .background(selectedDevice == device ? .secondary.opacity(0.2) : Color.gray.opacity(0.00001))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        selectedDevice = device
                    }
            }
            .frame(width: 200)
            .listStyle(SidebarListStyle())
            VStack {
                if selectedDevice == nil {
                    Text("Anywakey 1.0")
                } else {
                    detailView
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .background(BlurredEffect().ignoresSafeArea())
//        .frame(minWidth: 500)
        
    }
    
    private var detailView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Name:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.name.isEmpty ? "No value" : selectedDevice!.name)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text("Address:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.BroadcastAddr.isEmpty ? "No value" : selectedDevice!.BroadcastAddr)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text("MAC:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.MAC.isEmpty ? "No value" : selectedDevice!.MAC)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text("Port:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.Port.isEmpty ? "No value" : selectedDevice!.Port)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    //MARK: Textfields
    var addressField: some View {
        ZStack {
            VStack {
                HStack {
                    Text(" IP / Broadcast Address:")
                    Spacer()
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
    //    var status: some View {
    //        HStack {
    //            Text("Status:")
    //                .foregroundColor(DrawingConstants.statusTextColor)
    //                .opacity(DrawingConstants.statusTextOpacity)
    //            ZStack {
    //                Circle()
    //                    .strokeBorder(lineWidth: 1)
    //                    .foregroundColor(getStatusColor())
    //                Circle()
    //                    .fill()
    //                    .foregroundColor(getStatusColor())
    //                    .opacity(0.1)
    //            }
    //            .frame(width: DrawingConstants.statusDiameter)
    //            .padding(.trailing, 5)
    //        }
    //    }
    
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
        WakeUpButton()
            .padding(.vertical, 8)
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
