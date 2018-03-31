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
