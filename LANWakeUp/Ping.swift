
import Foundation

class Ping {
    
    public enum OnlineDevice {
        case Online
        case Offline
        case Default
    }
    
    func performPing(ipAddress: String) -> OnlineDevice {
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
                    print("Ping failed with error code \(task.terminationStatus)")
                    return .Offline
                }
            }
}
