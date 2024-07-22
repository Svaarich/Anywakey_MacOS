
import Foundation

public class Network {
    
    private init() {}
    
    static let instance = Network()
    
    private let wakeUp = WakeOnLAN()
    
    // Boot selected device
    func boot(device: Device) -> Error? {
        guard device.BroadcastAddr.isValidAddress(),
              device.MAC.isValidMAC(),
              device.Port.isValidPort()
        else { return nil }
        return wakeUp.target(device: device)
    }
    
    // Ping selected host / IP address and returns
//    func ping(address: String, onDone: @escaping (_ ping: Double, _ isAccessible: Bool) -> Void) {
//        // if address is empty returns false
//        guard
//            address.isValidAdress()
//        else { return onDone(0, false) }
//            let ones = try? SwiftyPing(host: address,
//                                       configuration: PingConfiguration(interval: 0.5, with: 2),
//                                       queue: DispatchQueue.global())
//            ones?.observer = { responce in
//                let isSuccess = responce.error == nil
//                DispatchQueue.main.async {
//                    onDone(responce.duration, isSuccess)
//                }
//            }
//            ones?.targetCount = 1
//            try? ones?.startPinging()
//    }
}


