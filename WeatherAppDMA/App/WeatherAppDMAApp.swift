import SwiftUI

@main
struct WeatherAppDMAApp: App {
    var body: some Scene {
        WindowGroup {
            CompositionRoot.makeCitiesView()
        }
    }
}
