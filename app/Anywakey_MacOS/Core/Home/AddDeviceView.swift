
import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Binding var showView: Bool
    @Binding var device: Device?
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var mac: String = ""
    @State private var port: String = ""
    
    @State private var hoverAdd: Bool = false
    @State private var hoverCancel: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // NAME
            AddTextField(prompt: "Device Name", text: $name)
            Text("Device Name")
            
            // ADDRESS
            AddTextField(prompt: "IP / Broadcast Address", text: $address)
            Text("IPv4(e.g. 192.168.0.123) or DNS name for the host.")
            
            // MAC
            AddTextField(prompt: "MAC Address", text: $mac)
            Text("(e.g. 00:11:22:AA:BB:CC)")
            
            // Port
            AddTextField(prompt: "Port", text: $port)
            Text("Typically sent to port 7 or 9")
            
            Spacer()
            
            HStack {
                addButton
                cancelButton
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension AddDeviceView {
    
    private enum FocusedStates: Hashable {
        case name
        case adress
        case mac
        case port
    }
}

extension AddDeviceView {
    
    // MARK: PROPERTIES
    
    // Add Button
    private var addButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showView = false
                device = Device(name: name,
                                MAC: mac,
                                BroadcastAddr: address,
                                Port: port)
                dataService.add(newDevice: device!)
            }
        } label: {
            Image(systemName: "plus")
        }
    }
}

