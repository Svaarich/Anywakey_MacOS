import SwiftUI

@main
struct LANWakeUpApp: App {
    private let computer = Computer()
    var body: some Scene {
        WindowGroup {
            LANWakeUpView(computer: computer)
                .frame(width: 400)
        }
        .windowResizabilityContentSize()
    }
}
