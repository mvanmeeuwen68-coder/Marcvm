import SwiftUI

@main
struct BeachGroovesRadioApp: App {
    @StateObject private var player = RadioPlayer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(player)
        }
    }
}
