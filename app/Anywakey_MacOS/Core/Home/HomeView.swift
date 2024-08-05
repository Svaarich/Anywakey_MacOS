
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
    @State private var showAddView = false
    @State private var selectedDevice: Device?
    
    @State private var status: Bool = false
    @State private var ping: Double = 0
    
    @State private var hoverAdd: Bool = false
    @State private var hoverDelete: Bool = false
    @State private var hoverCancel: Bool = false
    
    @State private var showDeleteConfirm: Bool = false
    
    @State var timer: Timer?
    
    var body: some View {
        
        HStack(spacing: 0) {
            // Device list
            if dataService.allDevices.isEmpty {
                emptyListView
            } else {
                deviceList
            }
            
            // Information view
            info
            
        }
        .background(BlurredEffect(.fullScreenUI).opacity(0.6).ignoresSafeArea())
        
        // init selected device 
        .onAppear {
            selectedDevice = dataService.allDevices.isEmpty ? nil : dataService.allDevices[0]
        }
        .onChange(of: selectedDevice) {
            
            withAnimation(.spring(duration: 0.3)) {
                showDeleteConfirm = false
            }
            
            getStatus()
            
            // restart timer
            timer?.invalidate()
            
            // if address is valid create timer
            guard selectedDevice != nil else { return }
            if selectedDevice!.BroadcastAddr.isValidAddress() {
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                    getStatus()
                }
            }
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.3)) {
                showDeleteConfirm = false
            }
        }
    }
}

#Preview {
    let dataService = DeviceDataService()
    return HomeView(dataService: dataService)
}

extension HomeView {
    
    // MARK: FUNCTIONS
    
    private func getStatus() {
        if selectedDevice?.BroadcastAddr != nil {
            Network.instance.ping(address: selectedDevice!.BroadcastAddr) { ping, status in
                withAnimation(.smooth(duration: 0.3)) {
                    self.ping = ping
                    self.status = status
                }
            }
        } else {
            withAnimation(.smooth(duration: 0.3)) {
                self.ping = 0.0
                self.status = false
            }
        }
        print("pinging - \(String(describing: selectedDevice?.BroadcastAddr))")
    }
    
    // MARK: PROPERTIES
    
    private var emptyListView: some View {
        VStack {
            Text("No devices")
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    showAddView = true
                }
            } label: {
                Text("Add device")
                    .foregroundStyle(.white)
                    .padding(6)
                    .padding(.horizontal, 6)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .frame(width: 200)
    }
    
    // InfoView
    private var info: some View {
        VStack {
            if showAddView {
                AddDeviceView(showView: $showAddView, device: $selectedDevice)
            } else {
                if selectedDevice == nil {
                    Text("Anywakey MacOS App")
                    Text("Version: \(Bundle.main.releaseVersionNumber ?? "")")
                        .foregroundStyle(.secondary)
                } else {
                    deviceInfo
                }
            }
        }
        .padding()
        .frame(minWidth: 350, minHeight: 450)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurredEffect(.fullScreenUI).ignoresSafeArea())
    }
    
    // Device List
    private var deviceList: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.clear)
            List(dataService.allDevices, selection: $selectedDevice) { device in
                Text("\(device.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6)
                    .padding(.horizontal, 6)
                    .background(selectedDevice == device ? .secondary.opacity(0.2) : Color.gray.opacity(0.00001))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedDevice = device
                            showAddView = false
                        }
                    }
            }
            .scrollIndicators(.never)
            .scrollContentBackground(.hidden)
            .listStyle(SidebarListStyle())
            
            HStack {
                addButton
                deleteButton
                if showDeleteConfirm {
                    cancelButton
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
                Spacer()
                if !showDeleteConfirm {
                    appInfoButton
                }
            }
            .padding(8)
        }
        .frame(width: 200)
    }
    
    // Device info view
    private var deviceInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            ParameterSection(
                header: "Name:",
                info: selectedDevice!.name.isEmpty ? "No Value" : selectedDevice!.name)
            
            ParameterSection(
                header: "IP / Host Name:",
                info: selectedDevice!.BroadcastAddr.isEmpty ? "No Value" : selectedDevice!.BroadcastAddr)
            
            ParameterSection(
                header: "MAC:",
                info: selectedDevice!.MAC.isEmpty ? "No Value" : selectedDevice!.MAC)
            
            ParameterSection(
                header: "Port:",
                info: selectedDevice!.Port.isEmpty ? "No Value" : selectedDevice!.Port)
            
            HStack(spacing: 8) {
                statusInfo
                pingInfo
            }
            
            Spacer(minLength: 0)
            
            wolButton
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    //
    private var wolButton: some View {
        WakeUpButton(device: selectedDevice!)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
            .padding(.horizontal, 40)
    }
    
    // Status section
    
    private var statusInfo: some View {
        VStack(alignment: .leading) {
            Text("Status:")
                .fontWeight(.semibold)
                Text(status ? "online" : "offline")
                    .foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(alignment: .trailing) {
            Circle()
                .foregroundStyle(status ? .green.opacity(0.2) : .red.opacity(0.2))
                .overlay {
                    Circle()
                        .strokeBorder(lineWidth: 1)
                        .foregroundStyle(status ? .green : .red)
                    
                }
                .frame(width: 12, height: 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(6)
        }
    }
    
    // Ping section
    private var pingInfo: some View {
        VStack(alignment: .leading) {
            Text("Ping:")
                .fontWeight(.semibold)
            Text(status ? ping.pingAsString() : " - ms")
                .contentTransition(.numericText())
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // App info button
    
    private var appInfoButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showAppinfo = true
            }
        } label: {
            Image(systemName: "list.dash")
                .foregroundStyle(hoverAppInfo ? .white : .secondary)
                .padding(.horizontal, 8)
                .frame(height: 20)
                .background(Color.gray.opacity(hoverAppInfo ? 0.4 : 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverAppInfo ? 1.1 : 1.0)
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverAppInfo = hover
            }
        }
    }
    
    // Add button
    private var addButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showDeleteConfirm = false
                showAddView = true
            }
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(hoverAdd ? .white : .secondary)
                .padding(.horizontal, 8)
                .frame(height: 20)
                .background(Color.gray.opacity(hoverAdd ? 0.4 : 0.2))
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
    
    // Delete button
    private var deleteButton: some View {
        Button {
            guard selectedDevice != nil else { return }
            let index = dataService.allDevices.firstIndex(of: selectedDevice!)
            withAnimation(.spring(duration: 0.3)) {
                showDeleteConfirm.toggle()
                if !showDeleteConfirm {
                    dataService.delete(device: selectedDevice!)
                    if dataService.allDevices.isEmpty {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedDevice = nil
                        }
                    } else {
                        if index == 0 {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedDevice = dataService.allDevices[index!]
                            }
                        } else {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedDevice = dataService.allDevices[index! - 1]}
                        }
                    }
                }
            }
            
        } label: {
            HStack {
                if showDeleteConfirm {
                    Text("delete")
                        .foregroundStyle(hoverDelete ? .white : .secondary)
                        .contentTransition(.numericText())
//                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .frame(width: 60 ,height: 20)
                        .background(.red.opacity(hoverDelete ? 0.4 : 0.2))
                    
                    
                } else {
                    Image(systemName: "minus")
                        .foregroundStyle(hoverDelete ? .white : .secondary)
//                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .frame(width: 30, height: 20)
                        .background(.gray.opacity(hoverDelete ? 0.4 : 0.2))
                }
            }
            
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
        .scaleEffect(hoverDelete ? 1.1 : 1.0)
        .onHover { hover in
            withAnimation(.spring(duration: 0.3)) {
                hoverDelete = hover
            }
        }
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showDeleteConfirm = false
            }
        } label: {
            Text("cancel")
                .foregroundStyle(hoverCancel ? .white : .secondary)
                .frame(width: 60 ,height: 20)
                .background(.blue.opacity(hoverCancel ? 0.4 : 0.2))
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
}
