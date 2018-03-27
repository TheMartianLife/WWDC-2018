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
    
    public convenience init(imageNamed image_name: String, triggers trigger: @escaping Action)
    {
        let texture = SKTexture(imageNamed: image_name)
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

public func makeControl(imageNamed image_name: String, at position: CGPoint, thatTriggers trigger: @escaping Action) -> SpriteButton
{
    let button = SpriteButton(imageNamed: image_name, triggers: trigger)
    button.name = image_name.components(separatedBy: ".").first
    button.position = position
    button.zPosition = 3
    button.setScale(CGFloat(4))
    button.texture!.filteringMode = .nearest
    
    return button
}
