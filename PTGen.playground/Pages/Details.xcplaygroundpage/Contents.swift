//: # Procedural Terrain Generation
//: What we've done... what we're going to do (weighted probabilities)
//: ## Now, let's add some variety
//#-hidden-code
import UIKit

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
//#-end-hidden-code
//: Now we want to add some difference in details, starting with variance in ground level. The **baseline** refers to the height on the *y* axis that the ground should average. The **variance** refers to how much this should be able to differ overall, while **max_step** dictates how much each height can be different to beside it--for ease of exploration, this should be kept low.
let baseline = 5
let variance = 3
let max_step = 2
//: We use these values to make an array of tuples, containing each possible choice and a weighted likelihood that it should occur.
func getGroundLevelPattern() -> [(Int, Double)]
{
    var ground_level: [(Int, Double)] = []
    var level_changes: [(Int, Double)] = []
    let var_range = (variance * 2) + 1
    let step_range = (max_step * 2) + 1

    for i in  -variance...variance
    {
        ground_level.append((baseline + i, 0.0))
    }

    for i in -max_step...max_step
    {
        level_changes.append((i, 0.0))
    }

    return [(-2, 0.1), (-1, 0.3), (0, 0.2), (1, 0.3), (2, 0.1)] //==================
}

let ground_pattern = getGroundLevelPattern()
//:
struct BlockCategory
{
    let components: [(type: Block, probability: Double)]
}

let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.7)])
let underground = BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
let surface = BlockCategory(components: [(dirt, 0.1), (grass, 0.9)])
// this block hidden, but explain
func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T
{
    let total_probability = options.reduce(0, { $0 + $1.probability })
    let random_selector = Double(arc4random_uniform(UInt32(total_probability*100))/100)
    var cumulative_probability = 0.0

    for item in options
    {
        if item.probability < random_selector
        {
            cumulative_probability += item.probability
        } else {
            return item.value
        }
    }

    return options[0].value
}
//:
func chooseBlock(x: Int, y: Int) -> Block
{
    let ground_level = chooseFrom(ground_pattern)
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

    return sky
}
//: ...and generate a world from these new rules to see the changes.
//generateWorld()
//: [< Introduction](Introduction) | [Features >](Features)

