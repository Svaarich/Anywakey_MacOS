
import Foundation

public enum OnlineDevice: Codable {
    case Online
    case Offline
    case Default
}

class Ping {
    
    func performPing(ipAddress: String) async -> OnlineDevice {
        if ipAddress.contains(".") {
            let task = Process()
            task.launchPath = "/sbin/ping"
            task.arguments = ["-c", "1", "-W", "0.5", ipAddress]
            
            let pipe = Pipe()
            task.standardOutput = pipe
            
            task.launch()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                return .Online
            } else {
//                print("Ping failed with error code \(task.terminationStatus)")
                return .Offline
            }
        }
        
        return .Default
    }
    
    func updateStatusList(devices: [WakeUp.Device]) async -> [WakeUp.Device] {
        var updatedStatusList = devices
        for index in 0..<devices.count {
            updatedStatusList[index].status = await performPing(ipAddress: devices[index].BroadcastAddr)
        }
        return updatedStatusList
    }
}
