
import Foundation

public struct Device: Hashable, Identifiable, Codable {
    
    init(name: String, MAC: String, BroadcastAddr: String, Port: String, isPinned: Bool = false, id: String = UUID().uuidString) {
        self.name = name == "" ? "[No Name]" : name
        self.MAC = MAC.uppercased()
        self.BroadcastAddr = BroadcastAddr
        self.Port = Port
        self.isPinned = isPinned
        self.id = id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        MAC = try container.decode(String.self, forKey: .MAC)
        BroadcastAddr = try container.decode(String.self, forKey: .BroadcastAddr)
        Port = try container.decode(String.self, forKey: .Port)
        isPinned = try container.decodeIfPresent(Bool.self, forKey: .isPinned) ?? false
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
    }
    
    // main
    let name: String
    let MAC: String
    let BroadcastAddr: String
    let Port: String
    let isPinned: Bool
    public var id = UUID().uuidString
    
    // return current device marked as favourite
    func pinToggle() -> Device {
        let updatedDevice = Device(name: name,
                                    MAC: MAC,
                                    BroadcastAddr: BroadcastAddr,
                                    Port: Port,
                                    isPinned: !isPinned,
                                    id: id)
        return updatedDevice
    }
}


