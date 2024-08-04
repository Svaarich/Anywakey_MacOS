
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
    @State private var showFileImporter: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Add new device")
                .font(.largeTitle)
                .padding(.bottom, 6)
            
        // NAME
            AddTextField(
                prompt: "Device Name",
                text: $name)
            Text("Device Name")
                .padding(.bottom, 6)
        
        // ADDRESS
            AddTextField(
                prompt: "IP / Broadcast Address",
                text: $address,
                isValid: address.isEmpty ? true : address.isValidAddress())
            Text("IPv4(e.g. 192.168.0.123) or DNS name for the host.")
                .padding(.bottom, 6)
        
            // MAC
            AddTextField(
                prompt: "MAC Address",
                text: $mac,
                isValid: mac.isEmpty ? true : mac.isValidMAC())
            Text("(e.g. 00:11:22:AA:BB:CC)")
                .padding(.bottom, 6)
            
            // Port
            AddTextField(
                prompt: "Port",
                text: $port,
                isValid: port.isEmpty ? true : port.isValidPort())
            Text("Typically sent to port 7 or 9")
            
            Spacer()
            
            HStack {
                addButton
                cancelButton
            }
        }
        .frame(maxWidth: .infinity)
        
        
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.text]) { result in
            do {
                let fileUrl = try result.get()
                if fileUrl.startAccessingSecurityScopedResource() {
                    dataService.importConfig(from: fileUrl)
                    showView = false
                    print("success")
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch {
                print("Error file reading. \(error)")
            }
        }
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
            Text("save")
                .foregroundStyle(.white)
                .padding(4)
                .padding(.horizontal, 4)
                .background(.blue.opacity(hoverAdd ? 1.0 : 0.7))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverAdd ? 1.1 : 1.0)
        
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverAdd = hover
            }
        }
    }
    
    // Cancel Button
    private var cancelButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showView = false
            }
        } label: {
            Text("cancel")
                .foregroundStyle(hoverCancel ? .white : .secondary)
                .padding(4)
                .padding(.horizontal, 4)
                .background(.gray.opacity(hoverCancel ? 0.6 : 0.4))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverCancel ? 1.1 : 1.0)
        
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverCancel = hover
            }
        }
    }
    
    // Import Button
    private var ImportButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showFileImporter = true
            }
        } label: {
            Text("import")
                .foregroundStyle(hoverImport ? .white : .secondary)
                .padding(4)
                .padding(.horizontal, 4)
                .background(.gray.opacity(hoverImport ? 0.6 : 0.4))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverImport ? 1.1 : 1.0)
        
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverImport = hover
            }
        }
    }
}



