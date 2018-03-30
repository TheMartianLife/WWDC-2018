import SpriteKit

public typealias Action = () -> Void

public class SpriteButton: SKSpriteNode
{
    var trigger: Action?
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    public convenience init(imageNamed imageName: String, triggers trigger: @escaping Action)
    {
        let texture = SKTexture(imageNamed: imageName)
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
        isUserInteractionEnabled = true
        self.trigger = trigger
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        trigger?()
    }
}

public func makeControl(imageNamed imageName: String, at position: CGPoint, thatTriggers trigger: @escaping Action) -> SpriteButton
{
    let button = SpriteButton(imageNamed: imageName, triggers: trigger)
    button.anchorPoint = CGPoint(x: 0, y: 0)
    button.position = position
    button.setScale(CGFloat(blockSize / textureSize))
    button.texture!.filteringMode = .nearest
    
    return button
}
