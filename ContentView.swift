import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: WallpaperStore
    @State private var search = ""
    @State private var category: WallpaperCategory = .featured
    @State private var selected: Wallpaper?

    private var results: [Wallpaper] {
        store.wallpapers.filter {
            (category == .featured || $0.category == category) &&
            (search.isEmpty || $0.title.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("发现你的下一张壁纸")
                            .font(.largeTitle.bold())
                            .padding(.top, 10)
                        Text("适配 iOS 27 锁屏与主屏")
                            .foregroundStyle(.secondary)
                        categoryPicker
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(results) { wallpaper in
                                WallpaperCard(wallpaper: wallpaper, isFavorite: store.favorites.contains(wallpaper.id)) {
                                    selected = wallpaper
                                } onFavorite: {
                                    store.toggleFavorite(wallpaper)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("壁纸库")
                .searchable(text: $search, prompt: "搜索壁纸")
                .sheet(item: $selected) { wallpaper in
                    WallpaperDetail(wallpaper: wallpaper)
                        .environmentObject(store)
                }
            }
            .tabItem { Label("发现", systemImage: "sparkles") }

            FavoritesView().environmentObject(store)
                .tabItem { Label("收藏", systemImage: "heart") }

            SettingsGuideView()
                .tabItem { Label("如何设置", systemImage: "gearshape") }
        }
        .tint(.indigo)
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(WallpaperCategory.allCases) { item in
                    Button(item.rawValue) { category = item }
                        .buttonStyle(.borderedProminent)
                        .tint(category == item ? .indigo : .gray.opacity(0.25))
                        .foregroundStyle(category == item ? .white : .primary)
                }
            }
        }
    }
}

struct WallpaperCard: View {
    let wallpaper: Wallpaper
    let isFavorite: Bool
    let onOpen: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        Button(action: onOpen) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: wallpaper.imageURL) { phase in
                    if let image = phase.image { image.resizable().scaledToFill() }
                    else { Color.gray.opacity(0.2).overlay { ProgressView() } }
                }
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .pink : .white)
                        .padding(10)
                        .background(.black.opacity(0.35), in: Circle())
                }
                .padding(10)
            }
        }
        .buttonStyle(.plain)
    }
}

struct WallpaperDetail: View {
    @EnvironmentObject private var store: WallpaperStore
    @Environment(\.dismiss) private var dismiss
    let wallpaper: Wallpaper
    @State private var status = ""
    @State private var saving = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AsyncImage(url: wallpaper.imageURL) { phase in
                    if let image = phase.image { image.resizable().scaledToFill() }
                    else { ProgressView() }
                }
                .frame(maxHeight: 560)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                Text(wallpaper.title).font(.title.bold())
                Button {
                    Task {
                        saving = true
                        do {
                            try await ImageDownloader.saveToPhotos(url: wallpaper.imageURL)
                            store.downloaded.insert(wallpaper.id)
                            status = "已保存到照片图库"
                        } catch { status = error.localizedDescription }
                        saving = false
                    }
                } label: {
                    Label(saving ? "保存中…" : "下载到照片", systemImage: "arrow.down.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(saving)
                if !status.isEmpty { Text(status).font(.footnote).foregroundStyle(.secondary) }
                Text("下载后，在系统“设置 > 墙纸”中应用。")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("预览")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
        }
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var store: WallpaperStore
    var body: some View {
        NavigationStack {
            List(store.wallpapers.filter { store.favorites.contains($0.id) }) { wallpaper in
                HStack {
                    AsyncImage(url: wallpaper.imageURL) { $0.resizable().scaledToFill() } placeholder: { Color.gray.opacity(0.2) }
                        .frame(width: 56, height: 72).clipShape(RoundedRectangle(cornerRadius: 8))
                    Text(wallpaper.title)
                }
            }
            .navigationTitle("我的收藏")
        }
    }
}

struct SettingsGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("静态壁纸") {
                    Label("下载壁纸到照片图库", systemImage: "1.circle.fill")
                    Label("打开 设置 > 墙纸 > 添加新墙纸", systemImage: "2.circle.fill")
                    Label("从照片中选择刚才保存的图片", systemImage: "3.circle.fill")
                }
                Section("互动壁纸") {
                    Text("如需锁屏播放动效，请下载 Live Photo 资源，再在系统墙纸设置中选择 Live Photo。App 不能直接替你修改系统壁纸。")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("如何设置")
        }
    }
}
