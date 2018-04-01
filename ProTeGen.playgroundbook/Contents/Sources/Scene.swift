import SpriteKit
import PlaygroundSupport

// some co-ordinates used throughout for placing/anchoring sprites
let origin = CGPoint(x: 0, y: 0)
let midpoint = CGPoint(x: (worldWidth * blockSize) / 2, y: (worldHeight * blockSize) / 2)
let rightCorner = CGPoint(x: worldWidth * blockSize, y: 0)

/**
 Time type dictates whether scene is drawn in night mode or not
 */
public enum Time
{
    case day
    case night
}

// Z used to keep track of z-axis ordering of sprites
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

// the meat of the playground: the part that draws the scene based on the data in the World's block array and parameters defined by the user
public class Scene
{
    let worldWidth: Int // how many blocks wide
    let worldHeight: Int // how many blocks high
    let scene: SKScene // the scene we're drawing into
    let character: SKSpriteNode // the character so we don't have to keep importing her
    
    
    /// make a new scene to draw a world into
    public init(_ worldWidth: Int, _ worldHeight: Int)
    {
        self.worldWidth = worldWidth
        self.worldHeight = worldHeight
        
        // give it a frame to sit in
        let frame = CGRect(origin: origin, size: CGSize(width: worldWidth * blockSize, height: worldHeight * blockSize))
        let view = SKView(frame: frame)
        
        // set it to always fit when rotated, and hand it to the liveview
        scene = SKScene(size: frame.size)
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
        PlaygroundPage.current.liveView = view
        
        // store the character to be added each time
        character = SKSpriteNode(texture: SKTexture(imageNamed: "character.png"))
    }
    
    /// draw the blocks in the scene
    public func draw(_ world: Generatable, _ biome: Biome = .normal, _ time: Time = .day, noControls: Bool = false)
    {
        var sprite: SKSpriteNode
        
        // remove all sprites in scene, in case of refreshing
        scene.removeAllChildren()

        // place the background sprite, stretched to cover the scene
        sprite = SKSpriteNode(texture: SKTexture(image: biome.backgroundImage))
        sprite.size = CGSize(width: worldWidth * blockSize, height: worldHeight * blockSize)
        sprite.position = midpoint
        sprite.zPosition = Z.background.position
        scene.addChild(sprite)

        // now go through each block in the World's blocks array, one by one
        for x in 0..<worldWidth
        {
            for y in 0..<worldHeight
            {
                let block = world[x, y]

                // if it's air, don't draw it
                if block.collision == .none
                {
                    continue
                }

                // if it's got a texture, use that
                if block.texture != nil
                {
                    sprite = SKSpriteNode(texture: SKTexture(image: block.texture!))
                // otherwise make one using its defined colour
                } else {
                    sprite = SKSpriteNode(color: block.color, size: CGSize(width: textureSize, height: textureSize))
                }

                // draw it on the z-axis based on its collision type
                switch block.collision
                {
                    case .background: sprite.zPosition = Z.behindCharacter.position
                    case .solid: sprite.zPosition = Z.atCharacter.position
                    case .foreground: sprite.zPosition = Z.beforeCharacter.position
                    case .varied: sprite.zPosition = chooseFrom([(Z.behindCharacter.position, 0.7), (Z.beforeCharacter.position, 0.3)])
                    case .none: break
                }

                // if it should be see-through, make it so
                if block.opacity == .transparent
                {
                    sprite.alpha = 0.8
                }

                // place it in the world, positioned based on its array index
                sprite.setScale(spriteScale)
                sprite.anchorPoint = origin
                sprite.position = CGPoint(x: x * blockSize, y: y * blockSize)
                scene.addChild(sprite)
            }
        }

        // now that the blocks are in, place the character on them
        placeCharacter(in: world)

        // apply the relevant changes if it should be night mode
        if time == .night
        {
            self.makeNight()
        }
        
        // switch so that we can make page 1 not show a button that will appear to not do anything and confuse the user
        if !noControls
        {
            // add a button that recursively calls this when touched, allowing for the blanket "scene.removeAllChildren" we used at the beginning. Much faster than checking each node in the scene and only removing it if it were not a button, or drawing the button in another view on top of the current scene.
            addControl("redraw_button.png")
            {
                // seed the random number generator when pressed, allowing me to seed the initial values for each page--ensuring a nice first outcome--without ruining the whole fun part
                srand48(Int(arc4random_uniform(1000000000)))
                
                // get a new world, now properly random, and draw it
                world.clear()
                world.generate()
                self.draw(world, biome, time)
            }
        }
    }
    
    /// place the character into the scene, based on the ground height in the middle of the scene
    func placeCharacter(in world: Generatable)
    {
        let middleBlock = (worldWidth - 1) / 2 // if even-numbered, pick the block left of middle
        var groundHeight = 0 // start checking from the bottom, as this is less steps on average
        
        for y in 0..<worldHeight
        {
            let block = world[middleBlock, y]
            
            if  block.collision != .solid // if the block is no longer underground
            {
                groundHeight = y // this is the height the character should be at
                break
            }
        }
        
        // place it in the scene
        character.anchorPoint = origin
        character.position = CGPoint(x: middleBlock * blockSize, y: groundHeight * blockSize)
        character.setScale(spriteScale)
        scene.addChild(character)
    }
    
    /// place the refresh button into the scene, anchored to the corner for ease of thumb-reaching
    func addControl(_ imageName: String, thatTriggers trigger: @escaping Action)
    {
        let button = SpriteButton(imageNamed: imageName, triggers: trigger)
        button.anchorPoint = CGPoint(x: 1, y: 0)
        button.position = rightCorner
        button.zPosition = Z.controls.position
        button.setScale(spriteScale)
        scene.addChild(button)
    }
    
    /// draw the scene in night mode
    func makeNight()
    {
        let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "night.jpg")!))
        let filter = SKSpriteNode(color: #colorLiteral(red: 0.02352941176, green: 0.1254901961, blue: 0.2196078431, alpha: 1), size: CGSize(width: worldWidth * blockSize, height: worldHeight * blockSize))
        
        // put the starry background into the scene
        background.size = CGSize(width: worldWidth * blockSize, height: worldHeight * blockSize)
        background.texture!.filteringMode = .nearest
        background.position = midpoint
        background.zPosition = Z.backgroundFilter.position
        scene.addChild(background)
        
        // put a dark filter over everything but the button
        filter.alpha = 0.5
        filter.position = midpoint
        filter.zPosition = Z.foregroundFilter.position
        scene.addChild(filter)
    }
}

