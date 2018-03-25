//CHANGE ANCHOR POINT TO CENTER BOTTOM?
import SpriteKit
import PlaygroundSupport

public class Scene: CustomDebugStringConvertible
{
    let world_width: Int
    let world_height: Int
    let texture_size: Int
    let scale: Int
    let sprite_scale: Double
    let frame: CGRect
    let scene: SKScene
    let view: SKView
    let middle_block: Double
    let middle: Double
    let character: SKSpriteNode
    
    public init(world_width: Int, world_height: Int, scale: Int, texture_size: Int)
    {
        self.world_width = world_width
        self.world_height = world_height
        self.scale = scale
        self.texture_size = texture_size
        self.sprite_scale = Double(scale) / Double(texture_size)
        
        frame = CGRect(x: 0, y: 0, width: CGFloat(world_width * scale), height: CGFloat(world_height * scale))
        view = SKView(frame: frame)
        
        middle_block = floor(Double((world_width + 1) / 2))
        middle = (middle_block - 0.5) * Double(scale)
        character = SKSpriteNode(texture: SKTexture(image: UIImage(named: "character.png")!))
        character.texture!.filteringMode = .nearest
        
        character.setScale(CGFloat(sprite_scale))
        scene = SKScene(size: frame.size)
        scene.scaleMode = .aspectFit
    }
    
    public func draw(_ world: World, _ background_color: UIImage)
    {
        var sprite: SKSpriteNode
        
        sprite = SKSpriteNode(texture: SKTexture(image: background_color))
        sprite.size = CGSize(width: frame.width, height: frame.height)
        sprite.position = CGPoint(x: frame.width / 2, y: frame.width / 2)
        sprite.zPosition = -2
        scene.addChild(sprite)
        
        for x in 0..<world.width
        {
            for y in 0..<world.height
            {
                let block = world[x, y]

                if block == nil
                {
                    continue
                }
                
                if block!.texture != nil
                {
                    sprite = SKSpriteNode(texture: SKTexture(image: block!.texture!))
                    sprite.texture!.filteringMode = .nearest
                } else {
                    sprite = SKSpriteNode(color: block!.color, size: CGSize(width: texture_size, height: texture_size))
                }
                
                switch block!.collision
                {
                    case .background: sprite.zPosition = -1
                    case .solid: sprite.zPosition = 0
                    case .foreground: sprite.zPosition = 1
                    case .varied: sprite.zPosition = chooseFrom([(-1, 0.7), (1, 0.3)])
                }
                
                if block!.opacity == .transparent
                {
                    sprite.alpha = 0.8
                }
                
                sprite.setScale(CGFloat(sprite_scale))
                sprite.position = CGPoint(x: (x * scale) + (scale / 2), y: ((y * scale) + (scale / 2)))
                scene.addChild(sprite)
            }
        }
        
        placeCharacter(in: world)
        
        view.presentScene(scene)
        PlaygroundPage.current.liveView = view
    }
    
    func placeCharacter(in world: World)
    {
        var middle_ground: Double
        var height = 0
        
        for i in (0..<world.height).reversed()
        {
            let block = world[Int(middle_block - 1), i]
            
            if  block != nil && block!.collision == .solid
            {
                height = i + 2
                break
            }
        }
        
        middle_ground = Double(height * scale)
        character.position = CGPoint(x: middle, y: middle_ground)
        scene.addChild(character)
    }
    
    public func update(_ world: World)
    {
        
    }
    
    public var debugDescription : String {
        return "Scene"
    }
}

