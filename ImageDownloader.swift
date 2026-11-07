import Foundation
import Photos
import UIKit

enum ImageDownloadError: LocalizedError {
    case invalidImage
    var errorDescription: String? { "无法读取这张壁纸，请稍后重试。" }
}

enum ImageDownloader {
    static func saveToPhotos(url: URL) async throws {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw ImageDownloadError.invalidImage }
        try await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}
