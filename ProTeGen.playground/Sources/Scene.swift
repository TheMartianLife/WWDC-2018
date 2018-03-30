//CHANGE ANCHOR POINT TO CENTER BOTTOM?
import SpriteKit
import PlaygroundSupport

public enum Time
{
    case day
    case night
}

enum Z: CGFloat
{
    case background = -1.5
    case backgroundFilter = -1.0
    case behindCharacter = -0.5
    case atCharacter = 0.0
    case beforeCharacter = 0.5
    case foregroundFilter = 1.0
    case controls = 1.5
    
    var position: CGFloat
    {
        return self.rawValue
    }
}

public class Scene: CustomDebugStringConvertible
{
    let worldWidth: Int
    let worldHeight: Int
    let frame: CGRect
    let view: SKView
    let scene: SKScene
    let character: SKSpriteNode
    
    public init(_ worldWidth: Int, _ worldHeight: Int)
    {
        self.worldWidth = worldWidth
        self.worldHeight = worldHeight
        
        frame = CGRect(x: 0, y: 0, width: CGFloat(worldWidth * blockSize), height: CGFloat(worldHeight * blockSize))
        view = SKView(frame: frame)

        character = SKSpriteNode(texture: SKTexture(imageNamed: "character.png"))
        //character.texture!.filteringMode = .nearest
        
        scene = SKScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        view.presentScene(scene)
        PlaygroundPage.current.liveView = view
    }

    public func draw(_ world: Generatable, _ biome: Biome)
    {
        self.draw(world, biome, .day)
    }
    
    public func draw(_ world: Generatable, _ biome: Biome, _ time: Time)
    {
        var sprite: SKSpriteNode
        
        scene.removeAllChildren()
        scene.backgroundColor = biome.backgroundColor

        sprite = SKSpriteNode(texture: SKTexture(image: biome.backgroundImage))
        sprite.size = CGSize(width: frame.width, height: frame.height)
        sprite.position = CGPoint(x: 0, y: frame.height / 2)
        sprite.zPosition = Z.background.position
        scene.addChild(sprite)

        for x in 0..<worldWidth
        {

            for y in 0..<worldHeight
            {
                let block = world[x, y]

                if block.collision == .none
                {
                    continue
                }

                if block.texture != nil
                {
                    sprite = SKSpriteNode(texture: SKTexture(image: block.texture!))
                    sprite.texture!.filteringMode = .nearest
                } else {
                    sprite = SKSpriteNode(color: block.color, size: CGSize(width: textureSize, height: textureSize))
                }

                switch block.collision
                {
                    case .background: sprite.zPosition = Z.behindCharacter.position
                    case .solid: sprite.zPosition = Z.atCharacter.position
                    case .foreground: sprite.zPosition = Z.beforeCharacter.position
                    case .varied: sprite.zPosition = chooseFrom([(Z.behindCharacter.position, 0.7), (Z.beforeCharacter.position, 0.3)])
                    case .none: break
                }

                if block.opacity == .transparent
                {
                    sprite.alpha = 0.8
                }

                sprite.setScale(1 / CGFloat(textureSize / blockSize))
                sprite.anchorPoint = CGPoint(x: 0, y: 0)
                sprite.position = CGPoint(x: (x - worldWidth / 2) * blockSize, y: y * blockSize)
                scene.addChild(sprite)
            }
        }

        placeCharacter(in: world)

        if time == .night
        {
            self.makeNight()
        }

        addControl("redraw_button.png")
        {
            srand48(Int(arc4random_uniform(1000000000)))

            world.clear()
            world.generate()
            self.draw(world, biome)
        }

        playSound(biome.soundFile)
    }
    
    func placeCharacter(in world: Generatable)
    {
        let middleBlock = floor(Double((worldWidth + 1) / 2))
        var middleGround: Int
        var height = 0
        
        for i in (0..<worldHeight).reversed()
        {
            let block = world[Int(middleBlock - 1), i]
            
            if  block.collision == .solid
            {
                height = i + 1
                break
            }
        }
        
        middleGround = height * blockSize
        character.anchorPoint = CGPoint(x: 0, y: 0)
        character.position = CGPoint(x: blockSize * -1 , y: middleGround)
        character.setScale(1 / CGFloat(textureSize / blockSize))
        scene.addChild(character)
    }
    
    
    public func addControl(_ imageName: String, thatTriggers trigger: @escaping Action)
    {
        let position = CGPoint(x: blockSize * -7 , y: blockSize * 2)

        let button = makeControl(imageNamed: imageName, at: position, thatTriggers: trigger)
            
        scene.addChild(button)
    }
    
    public func makeNight()
    {
        let filter = SKSpriteNode(color: #colorLiteral(red: 0.02352941176, green: 0.1254901961, blue: 0.2196078431, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
        filter.alpha = 0.5
        filter.position = CGPoint(x: 0, y: frame.height / 2)
        filter.zPosition = Z.foregroundFilter.position
        scene.addChild(filter)
        
        let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "night.jpg")!))
        background.size = CGSize(width: frame.width, height: frame.height)
        background.texture!.filteringMode = .nearest
        background.position = filter.position
        background.zPosition = Z.backgroundFilter.position
        scene.addChild(background)
        
        playSound("crickets")
    }
    
    public var debugDescription : String
    {
        return "Scene"
    }
}

