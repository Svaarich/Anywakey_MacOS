import SwiftUI

struct DeviceList: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @State private var isPresentedListOfDevices = false
    @State private var isHoverList = false
    @State private var isHoverDeleteButton = false
    
    @State private var currentHoverDevice: Device?
    
    var body: some View {
        ZStack {
            deviceListBackground
                .frame(width: 115, height: 30)
            HStack {
                Image(systemName: "desktopcomputer")
                Text("My devices")
            }
        }
        .scaleEffect(isPresentedListOfDevices ? 1.1 : 1)
        .onHover { hover in
            withAnimation {
                isHoverList = hover
                isPresentedListOfDevices = true
            }
        }
        .popover(isPresented: $isPresentedListOfDevices,
                 attachmentAnchor: .point(.bottom),
                 arrowEdge: .bottom) {
            if dataService.allDevices.isEmpty {
                Text("Empty!")
                    .padding()
            } else {
                VStack {
                    ForEach(dataService.allDevices) { device in
                        var isHover: Bool {
                            device == currentHoverDevice
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill()
                                .foregroundColor(.white)
                                .opacity(isHover ? 0.2 : 0.1)
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.white)
                                .opacity(isHover ? 0.5 : 0.3)
                            HStack {
                                Image(systemName: "checkmark")
                                    .opacity(pc == currentDevice ? 1 : 0)
                                if pc.status == .Online {
                                    HStack {
                                        Text(pc.name)
                                        Spacer()
                                        Text("online")
                                            .foregroundColor(Color.green)
                                    }
                                } else {
                                    HStack {
                                        Text(pc.name)
                                        Spacer()
                                        Text("offline")
                                            .foregroundColor(Color.pink)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                        }
                        .onHover { _ in
                            currentHoverDevice = device
                        }
                        .onTapGesture {
                            withAnimation {
                                dataService.displayedDevice = device
                                isPresentedListOfDevices = false
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical, 4)
                    deleteButton
                }
                .frame(width: 140)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .onAppear {
                    currentHoverDevice = dataService.displayedDevice
                }
            }
        }
    }
    var deleteButton: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill()
                    .foregroundColor(isHoverDeleteButton ? .pink : .white)
                    .opacity(isHoverDeleteButton ? 0.3 : 0.1)
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(isHoverDeleteButton ? .pink : .white)
                    .opacity(isHoverDeleteButton ? 0.6 : 0.5)
            }
            Text("Delete ")
                .foregroundColor(.white)
                .padding(.vertical, 4)
        }
        .onTapGesture {
            dataService.delete(device: dataService.displayedDevice)
            if let device = dataService.allDevices.first {
                dataService.displayedDevice = device
            }
            isPresentedListOfDevices.toggle()
        }
        .onHover { hover in
            isHoverDeleteButton.toggle()
        }
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
}
