//: Needs ground_level gen from before
//: Needs writing polish
//#-hidden-code
import UIKit
import SpriteKit
import PlaygroundSupport

// Define world size
let world_width = 10
let world_height = 8
let scale = 30

// Make a frame for it
let frame = CGRect(x: 0, y: 0, width: CGFloat(world_width * scale), height: CGFloat(world_height * scale))
var scene = SKScene(size: frame.size)
let view = SKView(frame: frame)

// Figure out the the middle for the character_position later
let middle_block = floor(Double((world_width + 1) / 2))
let middle = (middle_block - 0.5) * Double(scale)
let character = SKSpriteNode(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: scale / 2, height: scale * 2))
// background //item //ground & character //foreground


// live/update view behaviour func dec====================================


func updateView(with world: Array<Array<Block>>)
{
    var sprite: SKSpriteNode
    var middle_ground: Double

    for x in 0..<world_width
    {
        for y in 0..<world_height
        {
            let block = world[x][y]

            if block.texture != nil
            {
                sprite = SKSpriteNode(texture: SKTexture(image:block.texture!))
                sprite.texture?.filteringMode = .nearest
            } else {
                sprite = SKSpriteNode(color: block.color, size: CGSize(width: 4, height: 4))
            }

            switch (block.collision) {
                case .background: sprite.zPosition = -1
                case .solid: sprite.zPosition = 0
                case .foreground: sprite.zPosition = 1
                    sprite.alpha = 0.5
            }

            sprite.setScale(CGFloat(scale/4))
            sprite.position = CGPoint(x: ((x * scale) + (scale / 2)), y: ((y * scale) + (scale / 2)))
            scene.addChild(sprite)
        }
    }

    var height = 0
    for i in (0..<world_height).reversed()
    {
        if world[Int(middle_block - 1)][i].collision == .solid
        {
            height = i + 2
            break
        }
    }

    middle_ground = Double(height * scale)
    character.position = CGPoint(x: middle, y: middle_ground)
    scene.addChild(character)

    view.presentScene(scene)
    PlaygroundPage.current.liveView = view
}

struct Block
{
    let color: UIColor
    let texture: UIImage?
    let collision: CollisionType
}

enum CollisionType
{
    case solid
    case background
    case foreground
}

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

struct BlockCategory
{
    let components: [(type: Block, probability: Double)]
}

let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.7)])
let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
let surface = BlockCategory(components: [(dirt, 0.1), (grass, 0.9)])


let ground_pattern =  [(1, 0.1), (2, 0.2), (3, 0.3), (4, 0.1)]
let baseline = 5
let variance = 3
let max_step = 2

//#-end-hidden-code
//: # ProTeGen
//: What we've done...
//: ## Now, some features
//: Water collects in two ways: first, if the ground_level is below the water_table.
// Water: if > water_table && > ground_level

// Trees, rocks
func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int) -> Block
{
    var options: [(Block, Double)]

    if y < ground_level - 2
    {
        options = deep_underground.components
        return chooseFrom(options)
    }

    if y < ground_level
    {
        options = underground.components
        return chooseFrom(options)
    }

    if y == ground_level
    {
        options = surface.components
        return chooseFrom(options)
    }

    if y > ground_level && y <= water_table
    {
        return water
    }

    return sky
}
//:
func generateWorld()
{
    var world = [[Block]](repeating: [Block](repeating: sky, count: world_height), count: world_width)
    let water_table = baseline - variance

    for x in 0..<world_width
    {
        let ground_level = chooseFrom(ground_pattern)

        for y in 0..<world_height
        {
            world[x][y] = chooseBlock(x, y, ground_level, water_table)
        }
    }

    updateView(with: world)
}
//: ...and generate a world from these new rules to see the changes.
generateWorld()
//: [< Details](Details) | [Variety >](Variety)

