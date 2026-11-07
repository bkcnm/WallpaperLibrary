import Foundation
import Combine

@MainActor
final class WallpaperStore: ObservableObject {
    @Published var wallpapers = Wallpaper.samples
    @Published var favorites: Set<UUID> = []
    @Published var downloaded: Set<UUID> = []

    func toggleFavorite(_ wallpaper: Wallpaper) {
        if favorites.contains(wallpaper.id) { favorites.remove(wallpaper.id) }
        else { favorites.insert(wallpaper.id) }
    }
}
