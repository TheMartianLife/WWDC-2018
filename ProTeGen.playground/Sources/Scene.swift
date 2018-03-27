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
    let view: SKView
    let scene: SKScene
    let character: SKSpriteNode
    public var night: Bool = false
    
    public init(_ world_width: Int, _ world_height: Int, _ scale: Int, _ texture_size: Int)
    {
        self.world_width = world_width
        self.world_height = world_height
        self.scale = scale
        self.texture_size = texture_size
        self.sprite_scale = Double(scale) / Double(texture_size)
        
        frame = CGRect(x: 0, y: 0, width: CGFloat(world_width * scale), height: CGFloat(world_height * scale))
        view = SKView(frame: frame)

        character = SKSpriteNode(texture: SKTexture(imageNamed: "character.png"))
        character.texture!.filteringMode = .nearest
        
        character.setScale(CGFloat(sprite_scale))
        scene = SKScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
    }

    public func draw(_ world: World, _ background_color: UIImage)
    {
        var sprite: SKSpriteNode
        
        sprite = SKSpriteNode(texture: SKTexture(image: background_color))
        sprite.size = CGSize(width: frame.width, height: frame.height)
        sprite.position = CGPoint(x: 0, y: frame.width / 2)
        sprite.zPosition = -2
        scene.addChild(sprite)
        
        for x in 0..<world.width
        {
            let x_position = scale * (x - (world_width / 2)) + (scale / 2)
            
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
                sprite.position = CGPoint(x: x_position, y: ((y * scale) + (scale / 2)))
                scene.addChild(sprite)
            }
        }
        
        placeCharacter(in: world)
        
        view.presentScene(scene)
        PlaygroundPage.current.liveView = view
    }
    
    func placeCharacter(in world: World)
    {
        let middle_block = floor(Double((world_width + 1) / 2))
        let middle =  Double(scale) * ((middle_block - 0.5) - Double(world_width / 2))
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
        character.position = CGPoint(x: middle, y: middle_ground)//===============================
        scene.addChild(character)
    }
    
    public func addControls(for page_number: Page)
    {
        let lower_left = CGPoint(x: scale + (scale / 2) - scale * (world_width / 2), y: scale + (scale / 2))
        let lower_right = CGPoint(x: (world_width - 2) * scale + (scale / 2)  - scale * (world_width / 2), y: scale + (scale / 2))
        
        switch page_number
        {
        case .page1: break
            
        case .page2: break
            
        case .page3: break
            
        case .page4:
            let day_button = makeControl(imageNamed: "button.png", at: lower_left)
            {
                self.makeDay()
                playSound(wind_sound)//===============================================================
            }
        
            let night_button = makeControl(imageNamed: "button.png", at: lower_right)
            {
                self.makeNight()
                playSound(night_sound)
            }
        
            scene.addChild(day_button)
            scene.addChild(night_button)
            
        case .page5:
            let day_button = makeControl(imageNamed: "day_button.png", at: lower_left)
            {
                self.makeDay()
                playSound(wind_sound)//===============================================================
            }
            
            let night_button = makeControl(imageNamed: "night_button.png", at: lower_right)
            {
                self.makeNight()
                playSound(night_sound)
            }
            
            scene.addChild(day_button)
            scene.addChild(night_button)
        }
    }
    
    public func makeNight()
    {
        if !night
        {
            let filter = SKSpriteNode(color: #colorLiteral(red: 0.02352941176, green: 0.1254901961, blue: 0.2196078431, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
            filter.alpha = 0.4
            filter.position = CGPoint(x: 0, y: frame.height / 2)
            filter.zPosition = 2
            filter.name = "night_filter"
            scene.addChild(filter)
            
            let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "night.jpg")!))
            background.size = CGSize(width: frame.width, height: frame.height)
            background.texture!.filteringMode = .nearest
            background.position = filter.position
            background.zPosition = -2
            background.name = "night_background"
            scene.addChild(background)
        }
        
        night = true
    }
    
    public func makeDay()
    {
        if night
        {
            scene.childNode(withName: "night_filter")?.removeFromParent()
            scene.childNode(withName: "night_background")?.removeFromParent()
        }
        
        night = false
    }
    
    public var debugDescription : String
    {
        return "Scene"
    }
}

