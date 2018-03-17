//#-hidden-code
import UIKit
import SpriteKit
import PlaygroundSupport

func setUpWorld()
{
    let frame = CGRect(x: 0, y: 0, width: CGFloat(world_width * scale), height: CGFloat(world_height * scale))
    let center = CGPoint(x: frame.size.width/2.0, y: 0) // plus (one) integer div by (two)==========================
    var scene = SKScene(size: frame.size)
    let view = SKView(frame: frame)
} // live/update view behaviour func dec
//#-end-hidden-code
//: # Procedural Terrain Generation
//: What we're doing, why it's cool, what you can do with it, list of contents
//: ## First, let's make a world
//: We need something to make the world from. I will define a **Block** type that takes three parameters: a **color** for the block, a **texture** for the block, and a **collision** type. In cases where there is a texture file present, and the user has not set *low performance* mode, it will display this image file as the block. Otherwise, it will display a plain square of the given color. Collision type is used to define blocks that the player should walk on, appear in front of--such as the sky--or behind--such as water.
struct Block {
    let color: UIColor
    let texture: UIImage?
    let collision: CollisionType
}

enum CollisionType {
    case solid
    case background
    case foreground
}
//: Then we make some blocks with it...
let sky = Block(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), texture: UIImage(named: "sky.jpg"), collision: .background)
let grass = Block(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(color: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(color: #colorLiteral(red: 0.1937262056, green: 0.1253115404, blue: 0.05571718726, alpha: 1), texture: UIImage(named: ""), collision: .background)
let leaves = Block(color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), texture: UIImage(named: ""), collision: .foreground)
let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), texture: UIImage(named: "snow.jpg"), collision: .solid)
let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), texture: UIImage(named: ""), collision: .solid)
//: Now that we have some blocks, we need to define a world to put them in. First, some logistics: prioritise speed or performance with the **low_performance** toggle, decide on a zoom rate with **scale** and how many blocks to show at one time with **world_height** and **world_width** variables.
let low_performance = false
let scale = 10
let world_height = 16
let world_width = 64
//: Next, we define some rules for how blocks are arranged to generate the world.
// write placement rules, apply to dirt, sky

//==============================================
let block = grass

setUpWorld()
var world = [[Block]](repeating: Array(repeating: sky, count: world_height), count: world_width)

let sprite: SKSpriteNode
if !low_performance && block.texture != nil
{
    sprite = SKSpriteNode(texture: SKTexture(image: block.texture!))
} else {
    sprite = SKSpriteNode(color: block.color, size: CGSize(width: 4, height: 4))
}

sprite.position = center // thing based on array index
sprite.setScale(CGFloat(scale))
scene.addChild(sprite)

func generateWorld() -> Array<Array<Block>>
{
    return [[Block]](repeating: [Block](repeating: sky, count: world_height), count: world_width)
}

func updateView()
{
    for line in world
    {
        for image in line
        {
            print("block goes here")
        }
    }

    view.presentScene(scene)
    PlaygroundPage.current.liveView = view
}
//=========================================================================
generateWorld()
//: [< Extras](Beyond) | [Details >](Details)
