
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
    @State private var showAddView = false
    @State private var selectedDevice: Device?
    
    var body: some View {
        HStack(spacing: 0) {
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

            VStack {
                if showAddView {
                    AddDeviceView(showView: $showAddView, device: $selectedDevice)
                } else {
                    if selectedDevice == nil {
                        Text("Anywakey")
                    } else {
                        detailView
                    }
                }
            }
            .padding()
            .frame(minWidth: 350, minHeight: 450)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlurredEffect(.fullScreenUI).ignoresSafeArea())
        }
        .background(BlurredEffect(.fullScreenUI).opacity(0.6).ignoresSafeArea())
        .onAppear {
            selectedDevice = dataService.allDevices.isEmpty ? nil : dataService.allDevices[0]
        }
    }
    
    private var detailView: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text("Name:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.name.isEmpty ? "No value" : selectedDevice!.name)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(alignment: .leading) {
                Text("Address:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.BroadcastAddr.isEmpty ? "No value" : selectedDevice!.BroadcastAddr)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text("MAC:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.MAC.isEmpty ? "No value" : selectedDevice!.MAC)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text("Port:")
                    .fontWeight(.semibold)
                Text(selectedDevice!.Port.isEmpty ? "No value" : selectedDevice!.Port)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack(spacing: 8) {
                VStack(alignment: .leading) {
                    Text("Status:")
                        .fontWeight(.semibold)
                        Text("online")
                            .foregroundStyle(.secondary)
                            .overlay(alignment: .trailing) {
                                Circle()
                                    .foregroundStyle(.green.opacity(0.2))
                                    .overlay {
                                        Circle()
                                            .strokeBorder(lineWidth: 1)
                                            .foregroundStyle(.green)
                                            
                                    }
                                    .frame(height: 11)
                                    .offset(x: 15, y: 1)
                            }
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                VStack(alignment: .leading) {
                    Text("Ping:")
                        .fontWeight(.semibold)
                    Text("123 ms")
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
            }
    
            
            Spacer(minLength: 0)
            WakeUpButton(device: selectedDevice!)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(20)
                .padding(.horizontal, 40)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    let dataService = DeviceDataService()
    return HomeView(dataService: dataService)
}

extension HomeView {
    
    // MARK: PROPERTIES
    
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
            withAnimation(.spring(duration: 0.3)) {
                dataService.delete(device: selectedDevice!)
                if !dataService.allDevices.isEmpty {
                    selectedDevice = dataService.allDevices.first!
                } else {
                    selectedDevice = nil
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
