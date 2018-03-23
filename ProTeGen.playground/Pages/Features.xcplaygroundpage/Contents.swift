//#-hidden-code
// BETTER WATER
// SURFACE DETAILS
// CYCLICAL GENERATION OF GROUND (MODULO PROBLEM)

import UIKit

let world_width = 16
let world_height = 10
let scale = 30
let texture_size = 4

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)

let air = Block()
let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
let dark_wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)
let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), texture: UIImage(named: "snow.jpg"), collision: .solid)
let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), collision: .solid)

let baseline = 3
let variance = 3
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
let surface = BlockCategory(components: [(dirt, 0.2), (grass, 0.8)])
//#-end-hidden-code
//: # ProTeGen
//:
//: ## Now, some features
let long_grass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)

class ThirdWorld: World {
    func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int, _ world: World) -> Block?
    {
        let block = world[x, y]
        let block_below = blockBelow(x, y)
        var options: [(Block, Double)]
        
        if block != air
        {
            return block
        }
        
        if block_below == grass
        {
            return chooseFrom([(long_grass, 0.2), (air, 0.8)])
        }
        
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
            if y < water_table
            {
                return dirt
            }
            
            if surfaceBeside(x, y) == dirt
            {
                return grass
            }
            
            options = surface.components
            return chooseFrom(options)
        }
        
        if y > ground_level
        {
            if y <= water_table
            {
                return water
            }
            
            if block_below == dirt
            {
                makeTree(x, y)
                return wood
            }
        }
        
        return air
    }
    
    func makeTree(_ x: Int, _ y: Int)
    {
        let trunk_height = chooseFrom([(2, 0.4), (3, 0.4), (4, 0.2)])!
        
        for y in y..<(min(y + trunk_height, world.height))
        {
            world[x, y] = wood
        }
        
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunk_height - 1)...(y + trunk_height + 1)
            {
                if valid(x, y) && (world[x, y] == air || world[x, y]!.collision == .varied)
                {
                    world[x, y] = leaves
                }
            }
        }
        
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunk_height + 2
            
            if valid(x, y) && (world[x, y] == air)
            {
                world[x, y] = leaves
            }
        }
    }

    func generate()
    {
        
        let water_table = (baseline - variance) + 1
        var ground_level = baseline
        
        for x in 0..<world_width
        {
            let ground_pattern = getGroundLevelPattern(given: ground_level)
            ground_level = chooseFrom(ground_pattern)

            for y in 0..<world_height
            {
                world[x, y] = chooseBlock(x, y, ground_level, water_table, world)
            }
        }
    }
}

let world = ThirdWorld(world_width, world_height)
//: ...and now call it to see what you've made.
world.generate()
scene.draw(world)
//: [< Details](Details) | [Variety >](Variety)
