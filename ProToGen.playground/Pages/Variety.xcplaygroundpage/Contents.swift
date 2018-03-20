//#-hidden-code
import UIKit

let world_width = 16
let world_height = 10
let scale = 30
let texture_size = 4

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)

let air = Block()
let grass = Block(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(color: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(color: #colorLiteral(red: 0.1937262056, green: 0.1253115404, blue: 0.05571718726, alpha: 1), texture: UIImage(named: ""), collision: .background)
let leaves = Block(color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), texture: UIImage(named: ""), collision: .foreground, opacity: .transparent)
let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), texture: UIImage(named: "snow.jpg"), collision: .solid)
let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), texture: UIImage(named: ""), collision: .solid)

let baseline = 3
let variance = 2
let max_step = 1

func getGroundLevelPattern(given prev: Int) -> [(Int, Double)]
{
    var pattern_array: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((max_step + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        pattern_array.append((x, probability))
    }
    
    return pattern_array
}

struct BlockCategory
{
    let components: [(type: Block, probability: Double)]
}

let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
let surface = BlockCategory(components: [(dirt, 0.1), (grass, 0.9)])
//#-end-hidden-code
//: # ProTeGen
//:
//: ## And finally, some variety

struct Feature
{
    
}

struct Biome
{
    let temperature: Temperature
    let humidity: Humidity
    let features: [Feature]
}

enum Temperature
{
    case cold
    case moderate
    case hot
}

enum Humidity
{
    case wet
    case moderate
    case dry
}
//:
let normal = Biome(temperature: .moderate, humidity: .moderate, features: [])
let desert = Biome(temperature: .hot, humidity: .dry, features: [])
let jungle = Biome(temperature: .hot, humidity: .wet, features: [])
let snowy = Biome(temperature: .cold, humidity: .moderate, features: [])
//:
func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int, _ biome: Biome) -> Block?
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
    
    return air
}
func generateWorld()
{
    let world = World(world_width, world_height)
    var ground_level = baseline
    let water_table = (baseline - variance) + 1
    let biome = normal
    
    for x in 0..<world_width
    {
        let ground_pattern = getGroundLevelPattern(given: ground_level)
        ground_level = chooseFrom(ground_pattern)!
        
        for y in 0..<world_height
        {
            world[x, y] = chooseBlock(x, y, ground_level, water_table, biome)
        }
    }
    
    scene.draw(world)
}
//: ...and, once again, call it to see your world.
generateWorld()
//: [< Features](Features) | [Extras >](Beyond)
