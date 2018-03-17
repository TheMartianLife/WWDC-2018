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
}

setUpWorld()

// live/update view behaviour func dec
let base_ground_level = 3
let variance = 2

sprite.position = center // thing based on array index
sprite.setScale(CGFloat(scale))
scene.addChild(sprite)

func updateView(view: SKView)
{
    let sprite: SKSpriteNode

    for line in world
    {
        for block in line
        {
            if !low_performance && block.texture != nil
            {
                sprite = SKSpriteNode(texture: SKTexture(image: block.texture!))
            } else {
                sprite = SKSpriteNode(color: block.color, size: CGSize(width: 4, height: 4))
            }
        }
    }

    view.presentScene(scene)
    PlaygroundPage.current.liveView = view
}
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
//: Now we need to define a world to put them in. First, some logistics: prioritise speed or performance with the **low_performance** toggle, decide on a zoom rate with **scale** and how many blocks to show at one time with **world_height** and **world_width** variables.
let low_performance = false
let scale = 10
let world_height = 16
let world_width = 64

//: Next, we define some rules for how blocks are arranged to generate the world. Let's start simple: if it is the bottom block in the world--1 on the **y** axis--then the block should be dirt, otherwise it should be sky. This only requires a rule that knows where a block is in the world.
func chooseBlock(x: Int, y: Int) -> Block {
    let block: Block

    if y == 1
    {
        block = dirt
    }

    return block
}
//: Then wrap that in a function that will find a block for each position based on the rules it is given...
func generateWorld() -> Array<Array<Block>>
{
    let world = [[Block]](repeating: [Block](repeating: sky, count: world_height), count: world_width)

    for line in world.enumerated()
    {
        for (block_index, block) in line.enumerated()
        {
            block = chooseBlock(x: line, y: block_index)
        }
    }

    return world
}
//: ...and call it to see the world we have made.
generateWorld()
//: [< Extras](Beyond) | [Details >](Details)
