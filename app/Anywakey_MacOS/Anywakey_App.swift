import SwiftUI

@main
struct Anywakey_App: App {
    @StateObject private var dataService = DeviceDataService()
    var body: some Scene {
        WindowGroup {
            HomeView(dataService: dataService)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizabilityContentSize()
        .environmentObject(dataService)
    }
}
