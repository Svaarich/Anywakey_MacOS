
import Foundation

public class DeviceDataService: ObservableObject {
    
    @Published var displayedDevice: Device = Device(name: "", MAC: "", BroadcastAddr: "", Port: "")
    
    @Published var allDevices: [Device] = [] {
        didSet {
            saveUserDefaults()
        }
    }
    @Published var lastDeletedDevice: Device = Device(name: "", MAC: "", BroadcastAddr: "", Port: "")
    
    init() {
        fetchUserDefaults()
        if let device = allDevices.first {
            displayedDevice = device
        }
    }
    
    // Get list of saved devices from UserDefaults
    func fetchUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "devices") {
            do {
                let decoder = JSONDecoder()
                let savedDevices = try decoder.decode([Device].self, from: data)
                allDevices = savedDevices
            } catch {
                print("Unable to Decode devices (\(error))")
            }
        }
    }
    
    // Save list with devices into UserDefaults
    func saveUserDefaults() {
        let data = allDevices
        let userDefaults = UserDefaults.standard
        do {
            let encoder = JSONEncoder()
            let savedDevices = try encoder.encode(data)
            userDefaults.set(savedDevices, forKey: "devices")
        } catch {
            print("Unable to Encode Array of devices (\(error))")
        }
    }
    
    
    // Delete device from the array
    func delete(device: Device) {
        if let index = allDevices.firstIndex(where: { $0 == device }) {
            allDevices.remove(at: index)
            
        }
    }
    
    // Add device to the array
    func add(newDevice: Device) {
        allDevices.append(newDevice)
    }
    
    // toggles pin state of device
    func pinToggle(device: Device) {
        if let index = allDevices.firstIndex(where: { $0 == device } ) {
            allDevices[index] = device.pinToggle()
        }
    }
    
    // update edited device
    func updateDevice(oldDevice: Device, newDevice: Device) {
        if let index = allDevices.firstIndex(where: { $0 == oldDevice } ) {
            allDevices[index] = newDevice
        }
    }
    
    // import device
    func importDeviceFrom(JSON: String, onCompletion: @escaping (_ data: Device) -> () ) {
        if let jsonData = JSON.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let device = try decoder.decode(Device.self, from: jsonData)
                onCompletion(device)
            } catch let error {
                print("Unable to decode. Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getConfig() -> String {
        let encoder = JSONEncoder()
        // try encode data
        do {
            let data = try encoder.encode(allDevices)
            let export = String(data: data, encoding: .utf8)
            return export ?? ""
        } catch let error {
            print("Can not encode data. \(error.localizedDescription)")
            return ""
        }
    }
    
    func importConfig(from url: URL) {
        let decoder = JSONDecoder()
        do {
            let result = try String(contentsOf: url)
            if let jsonData = result.data(using: .utf8) {
                allDevices = try decoder.decode([Device].self, from: jsonData)
            }
            print(result)
        } catch {
            print("Error reading file. \(error)")
        }
    }
}

