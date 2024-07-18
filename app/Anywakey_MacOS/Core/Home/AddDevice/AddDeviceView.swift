
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
            }
            .textFieldStyle(.plain)
            .padding(4)
            .padding(.horizontal, 4)
            .background(.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            // ADDRESS
            // TODO: dfdf
            .focused($isFocused, equals: .adress)
            .focused($isFocused, equals: .mac)
            .focused($isFocused, equals: .port)
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
            withAnimation(.spring) {
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
