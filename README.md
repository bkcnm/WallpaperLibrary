# Wallpaper Library

一个面向 iOS 27 的 SwiftUI 壁纸库第一版。

## 已包含

- 分类浏览与关键词搜索
- 壁纸详情预览
- 收藏
- 下载到系统照片图库
- iOS 27 锁屏/主屏设置引导
- 为 Live Photo/动态壁纸预留资源模型

## 打开方式

1. 在 macOS 上安装支持 iOS 27.3 SDK 的 Xcode 27.3 或更新版本。
2. 新建一个 iOS App（SwiftUI、Swift），产品名填写 `WallpaperLibrary`。
3. 用本目录中的同名 `.swift` 文件替换新项目里的文件。
4. 在项目的 `Info` 中加入 `NSPhotoLibraryAddUsageDescription`，内容可填写：`用于保存你下载的壁纸。`
5. 选择 iOS 27 模拟器或真机运行。

当前示例目录使用公开图片 URL 作为演示数据。正式上线前，建议替换为自己的 CDN/API，并确认每张图片的版权与授权范围。

## 没有 Mac 时云端构建

把整个目录上传到 GitHub，再导入 Codemagic，选择 `codemagic.yaml` 中的 `ios_unsigned` 工作流即可生成 `WallpaperLibrary-unsigned.ipa`。该包没有签名，需要你用自己的签名工具处理后安装。

## 关于互动壁纸

iOS 允许用户把符合要求的 Live Photo 设置为锁屏动态壁纸，但第三方 App 不能直接替用户修改系统壁纸。App 能做的是把资源保存到照片图库，并引导用户在“设置 > 墙纸”中应用。后续接入 Live Photo 时，应为每个条目提供配对的静态图和视频资源。
