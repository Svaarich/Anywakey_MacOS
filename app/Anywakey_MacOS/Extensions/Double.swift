
import Foundation

extension Double {
    // Formates Double to String and return ping in ms
    func pingAsString() -> String {
        let ping = String(format: "%.1f", self * 1000)
        return ping + " ms"
    }
}
