import SwiftUI

@main
struct Anywakey_App: App {
    private let dataService = DeviceDataService()
    var body: some Scene {
        WindowGroup {
            HomeView(dataService: dataService)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 380)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizabilityContentSize()
    }
}
