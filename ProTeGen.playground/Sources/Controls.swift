import SpriteKit

public class SpriteNodeButton: SKSpriteNode {
    
    var parent_scene: Scene
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        self.parent_scene = Scene(world_width, world_height, 30, texture_size)
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    public convenience init(imageNamed image_name: String, in scene: Scene)
    {
        let texture = SKTexture(imageNamed: image_name)
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.parent_scene = scene
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        self.parent_scene = Scene(world_width, world_height, 30, texture_size)
        super.init(coder: aDecoder)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        respondToTouchIn(location, within: parent_scene)
    }
}

public func respondToTouchIn(_ location: CGPoint, within parent_scene: Scene)
{
    let day_button = parent_scene.scene.childNode(withName: "day_button")
    let night_button = parent_scene.scene.childNode(withName: "night_button")
    
    if day_button!.contains(location) {
        parent_scene.makeDay()
    } else if night_button!.contains(location) {
        parent_scene.makeNight()
    }
}

public func insertButton(imageNamed image_name: String, at position: CGPoint, within parent_scene: Scene)
{
    let button = SpriteNodeButton(texture: SKTexture(imageNamed: image_name))
    button.name = image_name.components(separatedBy: ".").first
    button.position = position
    button.setScale(CGFloat(4))
    button.texture!.filteringMode = .nearest
    parent_scene.scene.addChild(button)
}
