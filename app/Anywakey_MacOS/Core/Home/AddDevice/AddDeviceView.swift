
import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Binding var showView: Bool
    @Binding var device: Device?
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var mac: String = ""
    @State private var port: String = ""
    
    @FocusState private var isFocused: FocusedStates?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // NAME
            TextField("Device Name", text: $name)
            .focused($isFocused, equals: .name)
            .textFieldStyle(.plain)
            .padding(6)
            .padding(.horizontal, 6)
            
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(.secondary.opacity(0.6))
            )
            
            // ADDRESS
            TextField("IP / Broadcast Address", text: $address)
            .focused($isFocused, equals: .adress)
            .textFieldStyle(.plain)
            .padding(6)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(.secondary.opacity(0.6))
            )
            
            // MAC
            TextField("MAC Address", text: $mac)
            .focused($isFocused, equals: .mac)
            .textFieldStyle(.plain)
            .padding(6)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(.secondary.opacity(0.6))
            )
            
            // Port
            TextField("Port", text: $port)
            .focused($isFocused, equals: .port)
            .textFieldStyle(.plain)
            .padding(6)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(.secondary.opacity(0.6))
            )
            Spacer()
            
            addButton
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
