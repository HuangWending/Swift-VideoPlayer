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
        VStack {
            Button("选择视频文件", action: selectVideo)
                .padding()

            if let videoURL = selectedVideoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .onAppear {
                        setPlaybackRate(playbackRate)
                        setVolume(volume)
                    }
            }

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
        }
    }

    private func selectVideo() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String], in: .import)
        documentPicker.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }

    private func togglePlayback() {
        guard let player = videoPlayer else { return }

        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }

    private var videoPlayer: AVPlayer? {
        guard let videoURL = selectedVideoURL else { return nil }
        return AVPlayer(url: videoURL)
    }

    private func setPlaybackRate(_ rate: Float) {
        guard let player = videoPlayer else { return }
        player.rate = rate
    }

    private func setVolume(_ volume: Float) {
        guard let player = videoPlayer else { return }
        player.volume = volume
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
