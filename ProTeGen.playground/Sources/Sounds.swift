import AVFoundation

var player: AVAudioPlayer?

public func playSound(_ name: String)
{
    let fileName = name.components(separatedBy: ".")[0]
    let fileExtension = name.components(separatedBy: ".")[1]
    guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }

        player.numberOfLoops = -1
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}
