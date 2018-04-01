import SpriteKit

// typealiases niceness for being handed a non-returning function for a button to trigger
typealias Action = () -> Void

/**
 SpriteButton: an SKSpriteNode that triggers a given action when touched, acting as a UIButton equivalent in a SpriteKit-based scene. Originally intending to have more controls throughout the playground, this SKSpriteNode subclass was made as generic as possible.
 */
class SpriteButton: SKSpriteNode
{
    var trigger: Action?
    
    
    // initialise a normal node, associate and action with it
    convenience init(imageNamed imageName: String, triggers trigger: @escaping Action)
    {
        let texture = SKTexture(imageNamed: imageName)
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
        isUserInteractionEnabled = true
        self.trigger = trigger
    }
    
    // call to the superclass to initialise it properly
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    // appease the compiler, due to constraints of the superclass
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // make it act like a button, triggering its Action when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        trigger?()
    }
}
