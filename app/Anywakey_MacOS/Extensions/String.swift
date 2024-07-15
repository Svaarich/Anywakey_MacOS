import SwiftUI

extension String {
    
    // Broadcast address validator
    func isValidAdress() -> Bool {
        // IPv4 IPv6 validation
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        
        if self.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer
            return true
        } else if self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer
            return true
        } else {
            let range = NSRange(location: 0, length: self.utf16.count)
            let regex = try! NSRegularExpression(pattern: "[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,63}")
            // Host validation
            return regex.firstMatch(in: self, range: range) != nil
        }
    }
    
    // Port validator
    func isValidPort() -> Bool {
        if self.isEmpty {
            return true
        } else {
            if let _ = UInt16(self) {
                return true
            } else {
                return false
            }
        }
    }
    
    // MAC validator
    func isValidMAC() -> Bool {
        let regEx = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
}



