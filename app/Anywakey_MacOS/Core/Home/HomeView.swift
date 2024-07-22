
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
    @State private var showAddView = false
    @State private var selectedDevice: Device?
    
    @State private var status: Bool = false
    @State private var ping: Double = 0
    
    @State var timer: Timer?
    
    var body: some View {
        HStack(spacing: 0) {
            
            // Device list
            deviceList
            
            // Information view
            info
            
        }
        .background(BlurredEffect(.fullScreenUI).opacity(0.6).ignoresSafeArea())
        
        // init selected device 
        .onAppear {
            selectedDevice = dataService.allDevices.isEmpty ? nil : dataService.allDevices[0]
        }
        .onChange(of: selectedDevice) {
            getStatus()
            
            // restart timer
            timer?.invalidate()
            
            // if address is valid create timer
            guard selectedDevice!.BroadcastAddr.isValidAddress() else { return }
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                getStatus()
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
    
    // InfoView
    private var info: some View {
        VStack {
            if showAddView {
                AddDeviceView(showView: $showAddView, device: $selectedDevice)
            } else {
                if selectedDevice == nil {
                    Text("Anywakey")
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
                Spacer()
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
                .overlay(alignment: .trailing) {
                    Circle()
                        .foregroundStyle(status ? .green.opacity(0.2) : .red.opacity(0.2))
                        .overlay {
                            Circle()
                                .strokeBorder(lineWidth: 1)
                                .foregroundStyle(status ? .green : .red)
                            
                        }
                        .frame(height: 11)
                        .offset(x: 17, y: 1)
                }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // Ping section
    private var pingInfo: some View {
        VStack(alignment: .leading) {
            Text("Ping:")
                .fontWeight(.semibold)
            Text(ping.pingAsString())
                .contentTransition(.numericText())
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // Add button
    private var addButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                showAddView = true
            }
        } label: {
            Image(systemName: "plus")
                .frame(width: 30, height: 20)
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
    }
    
    // Delete button
    private var deleteButton: some View {
        Button {
            guard selectedDevice != nil else { return }
            let index = dataService.allDevices.firstIndex(of: selectedDevice!)
            withAnimation(.spring(duration: 0.3)) {
                dataService.delete(device: selectedDevice!)
            }
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
        } label: {
            Image(systemName: "minus")
                .frame(width: 30, height: 20)
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.borderless)
    }
}
