import SwiftUI

@main
struct LANWakeUpApp: App {
    private let computer = Computer()
    var body: some Scene {
        WindowGroup {
            LANWakeUpView(computer: computer)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 380)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizabilityContentSize()
    }
}
