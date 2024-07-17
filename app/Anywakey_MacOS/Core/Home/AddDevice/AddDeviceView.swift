
import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Binding var showView: Bool
    @Binding var device: Device?
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var mac: String = ""
    @State private var port: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // NAME
            TextField(text: $name, prompt: Text("Name")) {
                Text(name)
            }
            .textFieldStyle(.plain)
            .padding(4)
            .padding(.horizontal, 4)
            .background(.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            // ADDRESS
            // TODO: dfdf
            
            Spacer()
            
            addButton
        }
        .frame(maxWidth: .infinity)
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
