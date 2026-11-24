import Foundation
import AVFoundation
import MediaPlayer

final class RadioPlayer: ObservableObject {
    @Published var isPlaying = false
    @Published var volume: Float = 0.8 {
        didSet { player?.volume = volume }
    }
    @Published var errorMessage: String?

    private let streamURLString = "http://stream.beachgrooves.com:8080/"
    private var player: AVPlayer?
    private var failureObserver: NSObjectProtocol?

    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            errorMessage = "Unable to activate audio: \(error.localizedDescription)"
        }
        configureRemoteCommands()
        updateNowPlaying()
    }

    deinit {
        if let failureObserver { NotificationCenter.default.removeObserver(failureObserver) }
    }

    func togglePlayback() {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            play()
        }
        updateNowPlaying()
    }

    private func play() {
        guard let url = URL(string: streamURLString), url.host != nil else {
            errorMessage = "Invalid radio stream URL."
            return
        }
        if player == nil {
            let item = AVPlayerItem(url: url)
            failureObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemFailedToPlayToEndTime, object: item, queue: .main
            ) { [weak self] notification in
                DispatchQueue.main.async {
                    self?.isPlaying = false
                    self?.errorMessage = "The radio stream could not be played. Check the stream URL and audio format."
                    self?.updateNowPlaying()
                }
            }
            player = AVPlayer(playerItem: item)
            player?.volume = volume
        }
        player?.play()
        isPlaying = true
        errorMessage = nil
    }

    private func configureRemoteCommands() {
        let commands = MPRemoteCommandCenter.shared()
        commands.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if !self.isPlaying { self.togglePlayback() }
            return .success
        }
        commands.pauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if self.isPlaying { self.togglePlayback() }
            return .success
        }
        commands.togglePlayPauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.togglePlayback()
            return .success
        }
    }

    private func updateNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: "BeachGrooves Radio",
            MPMediaItemPropertyArtist: "World Off, Music On!",
            MPNowPlayingInfoPropertyIsLiveStream: true,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
    }
}
