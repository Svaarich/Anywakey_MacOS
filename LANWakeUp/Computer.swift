import Foundation

class Computer: ObservableObject {
    @Published var device = WakeUp.Device(MAC: "", BroadcastAddr: "", Port: "")
    @Published var listOfDevices: Array<WakeUp.Device> = []
    private var wakeUp = WakeUp()
    private var ping = Ping()
    
    func target(device: WakeUp.Device) -> Error? {
        wakeUp.target(device: device)
    }
    
    func fetchUserDefaults() {
        listOfDevices = wakeUp.fetchUserDefaults()
    }
    
    func saveUserDefaults() {
        wakeUp.saveUserDefaults(data: listOfDevices)
    }
    
    func delete(oldDevice: WakeUp.Device) {
        listOfDevices = wakeUp.delete(device: oldDevice, data: listOfDevices)
    }
    
    func add(newDevice: WakeUp.Device) {
        listOfDevices = wakeUp.add(newDevice: newDevice, data: listOfDevices)
    }
    
    @MainActor func currentDeviceStatus() {
        Task {
            device.status = await ping.performPing(ipAddress: device.BroadcastAddr)
        }
    }
    @MainActor func updateStatusList() {
        Task {
            listOfDevices = await ping.updateStatusList(devices: listOfDevices)
        }
    }
}

