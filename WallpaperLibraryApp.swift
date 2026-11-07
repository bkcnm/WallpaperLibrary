import SwiftUI

@main
struct WallpaperLibraryApp: App {
    @StateObject private var store = WallpaperStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
