import Foundation

enum WallpaperCategory: String, CaseIterable, Identifiable {
    case featured = "精选"
    case nature = "自然"
    case abstract = "抽象"
    case space = "星空"
    case minimal = "极简"

    var id: String { rawValue }
}

struct Wallpaper: Identifiable, Hashable {
    let id: UUID
    let title: String
    let category: WallpaperCategory
    let author: String
    let imageURL: URL
    let isMotion: Bool
}

extension Wallpaper {
    static let samples: [Wallpaper] = [
        .init(id: UUID(), title: "深海蓝", category: .featured, author: "Wallpaper Library", imageURL: URL(string: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200&q=85")!, isMotion: false),
        .init(id: UUID(), title: "山间晨雾", category: .nature, author: "Wallpaper Library", imageURL: URL(string: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&q=85")!, isMotion: false),
        .init(id: UUID(), title: "沙漠曲线", category: .abstract, author: "Wallpaper Library", imageURL: URL(string: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200&q=85")!, isMotion: false),
        .init(id: UUID(), title: "银河夜色", category: .space, author: "Wallpaper Library", imageURL: URL(string: "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1200&q=85")!, isMotion: false),
        .init(id: UUID(), title: "雾面灰阶", category: .minimal, author: "Wallpaper Library", imageURL: URL(string: "https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=1200&q=85")!, isMotion: false)
    ]
}
