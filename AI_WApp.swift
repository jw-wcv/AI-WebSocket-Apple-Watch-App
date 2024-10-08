import SwiftUI

@main
struct AI_W_Watch_AppApp: App {
    @StateObject private var webSocketManager = WebSocketManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    webSocketManager.connect()
                }
        }
    }
}
