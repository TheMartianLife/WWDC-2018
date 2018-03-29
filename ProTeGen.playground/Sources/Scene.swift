//CHANGE ANCHOR POINT TO CENTER BOTTOM?
import SpriteKit
import PlaygroundSupport

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
    let textureSize: Int
    let scale: Int
    let spriteScale: Double
    let frame: CGRect
    let view: SKView
    let scene: SKScene
    let character: SKSpriteNode
    public var night: Bool = false
    
    public init(_ worldWidth: Int, _ worldHeight: Int, _ scale: Int, _ textureSize: Int)
    {
        self.worldWidth = worldWidth
        self.worldHeight = worldHeight
        self.scale = scale
        self.textureSize = textureSize
        self.spriteScale = Double(scale) / Double(textureSize)
        
        frame = CGRect(x: 0, y: 0, width: CGFloat(worldWidth * scale), height: CGFloat(worldHeight * scale))
        view = SKView(frame: frame)

        character = SKSpriteNode(texture: SKTexture(imageNamed: "character.png"))
        character.texture!.filteringMode = .nearest
        
        character.setScale(CGFloat(spriteScale))
        scene = SKScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
    }

    public func draw(_ world: World, _ backgroundColor: UIImage)
    {
        var sprite: SKSpriteNode
        
        scene.removeAllChildren()
        
        sprite = SKSpriteNode(texture: SKTexture(image: backgroundColor))
        sprite.size = CGSize(width: frame.width, height: frame.height)
        sprite.position = CGPoint(x: 0, y: frame.height / 2)
        sprite.zPosition = -2
        scene.addChild(sprite)
        
        for x in 0..<worldWidth
        {
            let xPosition = scale * (x - (worldWidth / 2)) + (scale / 2)
            
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

                sprite.setScale(CGFloat(spriteScale))
                sprite.position = CGPoint(x: xPosition, y: ((y * scale) + (scale / 2)))
                scene.addChild(sprite)
            }
        }
        
        placeCharacter(in: world)
        
        view.presentScene(scene)
        PlaygroundPage.current.liveView = view
    }
    
    func placeCharacter(in world: World)
    {
        let middleBlock = floor(Double((worldWidth + 1) / 2))
        let middle =  Double(scale) * -0.5
        var middleGround: Double
        var height = 0
        
        for i in (0..<worldHeight).reversed()
        {
            let block = world[Int(middleBlock - 1), i]
            
            if  block.collision == .solid
            {
                height = i + 2
                break
            }
        }
        
        middleGround = Double(height * scale)
        character.position = CGPoint(x: middle, y: middleGround)//===============================
        scene.addChild(character)
    }
    
    public func addControls(for pageNumber: Page)
    {
        let lowerLeft = CGPoint(x: scale + (scale / 2) - scale * (worldWidth / 2), y: scale + (scale / 2))
        let lowerRight = CGPoint(x: (worldWidth - 2) * scale + (scale / 2)  - scale * (worldWidth / 2), y: scale + (scale / 2))
        
        switch pageNumber
        {
        case .page1: break
            
        case .page2: break
            
        case .page3: break
            
        case .page4: break
            
        case .page5:
            let dayButton = makeControl(imageNamed: "day_button.png", at: lowerLeft)
            {
                self.makeDay()
                playSound(windSound)//===============================================================
            }
            
            let nightButton = makeControl(imageNamed: "night_button.png", at: lowerRight)
            {
                self.makeNight()
                playSound(nightSound)
            }
            
            scene.addChild(dayButton)
            scene.addChild(nightButton)
        }
    }
    
    public func addControl(_ imageName: String, thatTriggers trigger: @escaping Action)
    {
        let lowerLeft = CGPoint(x: scale + (scale / 2) - scale * (worldWidth / 2), y: scale + (scale / 2))
        let lowerMiddle = CGPoint(x: scale - (scale / 2), y: scale + (scale / 2))
        let lowerRight = CGPoint(x: (scale / 2) + scale * (worldWidth - 2) - scale * (worldWidth / 2), y: scale + (scale / 2))
        
        let button = makeControl(imageNamed: imageName, at: lowerLeft)
        {
            trigger()
            self.addControl(imageName, thatTriggers: trigger)
        }
            
        scene.addChild(button)
    }
    
    public func makeNight()
    {
        if !night
        {
            let filter = SKSpriteNode(color: #colorLiteral(red: 0.02352941176, green: 0.1254901961, blue: 0.2196078431, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
            filter.alpha = 0.5
            filter.position = CGPoint(x: 0, y: frame.height / 2)
            filter.zPosition = Z.foregroundFilter.position
            filter.name = "night_filter"
            scene.addChild(filter)
            
            let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "night.jpg")!))
            background.size = CGSize(width: frame.width, height: frame.height)
            background.texture!.filteringMode = .nearest
            background.position = filter.position
            background.zPosition = Z.backgroundFilter.position
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

