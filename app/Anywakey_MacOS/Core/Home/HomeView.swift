
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
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
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        // open add window
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Button {
                        guard selectedDevice != nil else { return }
                        dataService.delete(device: selectedDevice!)
                    } label: {
                        Image(systemName: "minus")
                    }
                    Spacer()
                }
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
                .padding(8)
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
            .frame(minWidth: 300, minHeight: 300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .background(BlurredEffect().ignoresSafeArea())
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
            VStack(alignment: .leading) {
                Text("Status:")
                    .fontWeight(.semibold)
                Text("online")
                    .foregroundStyle(.secondary)
            }
            WakeUpButton()
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    let dataService = DeviceDataService()
    return HomeView(dataService: dataService)
}
