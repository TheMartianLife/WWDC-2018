import AVFoundation

var player: AVAudioPlayer?

public func playSound(_ name: String)
{
    guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }

        player.volume = 0 // start silent
        player.numberOfLoops = -1 // repeat forever
        player.play() // start playing
        player.setVolume(1, fadeDuration: 5) // fade in from previous volume
        
    } catch let error {
        print(error.localizedDescription)
    }
}
