import AVFoundation

var player: AVAudioPlayer?

/// drives all sounds playing throughout the experience
public func playSound(_ name: String)
{
    // get the url fof the filename you were given
    let url = Bundle.main.url(forResource: name, withExtension: "mp3")
    // try to activate an audio session with it, putting "try" everywhere because it could fail at every step, audio players are fickle
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
        guard let player = player else { return }

        // once the session has begun...
        player.volume = 0 // start silent
        player.numberOfLoops = -1 // set to repeat forever
        player.play() // start playing
        player.setVolume(1, fadeDuration: 5) // fade in from previous volume
        
    } catch let error {
        print(error.localizedDescription)
    }
}
