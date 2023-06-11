# Swift-VideoPlayer
Swift视频播放器
import AVFoundation
import AVKit
import SwiftUI

这些是导入所需的框架和库，包括 AVFoundation、AVKit 和 SwiftUI。


struct ContentView: View {
    @State private var selectedVideoURL: URL?
    @State private var isPlaying = false
    @State private var playbackRate: Float = 1.0
    @State private var volume: Float = 1.0

 var body: some View {
定义 ContentView 结构体，符合 View 协议。创建了一些状态变量，用于跟踪选择的视频文件、播放状态、播放速度和音量。


VStack {
    Button("选择视频文件", action: selectVideo)
        .padding()

创建一个垂直堆栈，包含一个按钮，用于触发 selectVideo 方法来选择视频文件。


if let videoURL = selectedVideoURL {
    VideoPlayer(player: AVPlayer(url: videoURL))
        .onAppear {
            setPlaybackRate(playbackRate)
            setVolume(volume)
        }
}

如果已选择了视频文件，将在视图中显示一个 VideoPlayer 视图，并通过 AVPlayer 和 selectedVideoURL 创建 AVPlayer 对象。使用 onAppear 修饰符来在视图出现时设置播放速度和音量。

HStack {
    Button(action: {
        isPlaying.toggle()
        togglePlayback()
    }) {
        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
            .font(.largeTitle)
    }
    .padding()

    Slider(value: $playbackRate, in: 0.5...2.0, step: 0.1, minimumValueLabel: Text("0.5"), maximumValueLabel: Text("2.0")) {
        Text("速度")
    }
    .padding()

    Slider(value: $volume, in: 0.0...1.0) {
        Text("音量")
    }
    .padding()
}

创建一个水平堆栈，包含播放/暂停按钮和两个滑块。点击按钮会切换播放状态并调用 togglePlayback 方法。滑块用于控制播放速度和音量。


private func selectVideo() {
    let dialog = NSOpenPanel()
    dialog.title = "选择视频文件"
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseDirectories = false
    dialog.canCreateDirectories = false
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = ["public.movie"]

    if dialog.runModal() == NSApplication.ModalResponse.OK {
        if let result = dialog.url {
            selectedVideoURL = result
            isPlaying = false
            playbackRate = 1.0
            volume = 1.0
        }
    }
}

selectVideo 方法用于打开文件选择对话框，让用户选择视频文件。设置对话框的标题、样式和允许的文件类型。如果用户选择了文件，将更新 selectedVideoURL 和其他状态变量。
private func togglePlayback() {
    guard let player = videoPlayer else { return }

    if isPlaying {
        player.play()
    } else {
        player.pause()
    }
}


togglePlayback 方法根据播放状态切换播放器的播放和暂停。
private var videoPlayer: AVPlayer? {
    guard let videoURL = selectedVideoURL else { return nil }
    return AVPlayer(url: videoURL)
}

videoPlayer 是一个计算属性，用于返回根据 selectedVideoURL 创建的 AVPlayer 对象。

private func setPlaybackRate(_ rate: Float) {
    guard let player = videoPlayer else { return }
    player.rate = rate
}

private func setVolume(_ volume: Float) {
    guard let player = videoPlayer else { return }
    player.volume = volume
}

setPlaybackRate 和 setVolume 方法用于设置播放速度和音量。
@main
struct VideoPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
VideoPlayerApp 是 macOS 应用程序的入口。定义了一个主要的窗口组，其中的内容为 ContentView。

导入 框架
import AVFoundation
import AVKit
import SwiftUI
import MobileCoreServices

struct ContentView: View {
    @State private var selectedVideoURL: URL?
    @State private var isPlaying = false
    @State private var playbackRate: Float = 1.0
    @State private var volume: Float = 1.0

    var body: some View {
定义 ContentView 结构体，符合 View 协议。创建了一些状态变量，用于跟踪选择的视频文件、播放状态、播放速度和音量。
VStack {
    Button("选择视频文件", action: selectVideo)
        .padding()
创建一个垂直堆栈，包含一个按钮，用于触发 selectVideo 方法来选择视频文件。
if let videoURL = selectedVideoURL {
    VideoPlayer(player: AVPlayer(url: videoURL))
        .onAppear {
            setPlaybackRate(playbackRate)
            setVolume(volume)
        }
}
如果已选择了视频文件，将在视图中显示一个 VideoPlayer 视图，并通过 AVPlayer 和 selectedVideoURL 创建 AVPlayer 对象。使用 onAppear 修饰符来在视图出现时设置播放速度和音量。
HStack {
    Button(action: {
        isPlaying.toggle()
        togglePlayback()
    }) {
        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
            .font(.largeTitle)
    }
    .padding()

    Slider(value: $playbackRate, in: 0.5...2.0, step: 0.1, minimumValueLabel: Text("0.5"), maximumValueLabel: Text("2.0")) {
        Text("速度")
    }
    .padding()

    Slider(value: $volume, in: 0.0...1.0) {
        Text("音量")
    }
    .padding()
}
创建一个水平堆栈，包含播放/暂停按钮和两个滑块。点击按钮会切换播放状态并调用 togglePlayback 方法。滑块用于控制播放速度和音量。
private func selectVideo() {
    let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String], in: .import)
    documentPicker.delegate = self
    UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
}
selectVideo 方法创建一个 UIDocumentPickerViewController，用于让用户选择视频文件。设置了文档类型为 kUTTypeMovie，并将 ContentView 设为其代理。通过 present 方法将其呈现给用户。
private func togglePlayback() {
    guard let player = videoPlayer else { return }

    if isPlaying {
        player.play()
    } else {
        player.pause()
    }
}
togglePlayback 方法根据播放状态切换播放器的播放和暂停。
private var videoPlayer: AVPlayer? {
    guard let videoURL = selectedVideoURL else { return nil }
    return AVPlayer(url: videoURL)
}
videoPlayer 是一个计算属性，用于返回根据 selectedVideoURL 创建的 AVPlayer 对象。
private func setPlaybackRate(_ rate: Float) {
    guard let player = videoPlayer else { return }
    player.rate = rate
}

private func setVolume(_ volume: Float) {
    guard let player = videoPlayer else { return }
    player.volume = volume
}
setPlaybackRate 和 setVolume 方法用于设置播放速度和音量。
extension ContentView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let videoURL = urls.first {
            selectedVideoURL = videoURL
            isPlaying = false
            playbackRate = 1.0
            volume = 1.0
        }
    }
}
通过扩展 ContentView，实现了 UIDocumentPickerDelegate 协议。在 didPickDocumentsAt 方法中，当用户选择了文件时，将更新 selectedVideoURL 和其他状态变量。
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}提供一个预览 ContentView 的预览提供程序。
