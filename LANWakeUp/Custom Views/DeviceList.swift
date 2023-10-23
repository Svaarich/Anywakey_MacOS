import SwiftUI

struct DeviceList: View {
    
    var computer: Computer
    var listOfDevices: Array<WakeUp.Device>
    
    @State var isPresentedListOfDevices = false
    @State var isHoverListOfDevices = false
    @State var isHoverDeleteButton = false
    @State var currentDevice: WakeUp.Device
    @State private var currentHoverDevice = WakeUp.Device(MAC: "",
                                                          BroadcastAddr: "",
                                                          Port: "")
    
    init(listOfDevices: [WakeUp.Device], currentDevice: WakeUp.Device, computer: Computer) {
        self.listOfDevices = listOfDevices
        self.currentDevice = currentDevice
        self.computer = computer
    }
    
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
                isHoverListOfDevices = hover
                isPresentedListOfDevices = true
            }
        }
        .popover(isPresented: $isPresentedListOfDevices,
                 attachmentAnchor: .point(.bottom),
                 arrowEdge: .bottom) {
            if listOfDevices.isEmpty {
                Text("Empty!")
                    .padding()
            } else {
                VStack {
                    ForEach(listOfDevices) { pc in
                        var isHover: Bool {
                            pc == currentHoverDevice
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
                            currentHoverDevice = pc
                        }
                        .onTapGesture {
                            withAnimation {
                                currentDevice = pc
                                computer.device = pc
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
                    currentHoverDevice = currentDevice
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
            computer.delete(oldDevice: computer.device)
            if let device = computer.listOfDevices.first {
                computer.device = device
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
