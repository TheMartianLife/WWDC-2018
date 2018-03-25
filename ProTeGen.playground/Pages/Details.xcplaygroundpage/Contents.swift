//#-hidden-code
// FIX RIDICULOUS STRUCTURE

import UIKit

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)

let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
let surface = BlockCategory(components: [(dirt, 0.1), (grass, 0.9)])

// CHANGE BIOME BASED ON USER INPUT
var biome = Biome.snowy
biome = Biome.normal
biome = Biome.desert
biome = Biome.jungle
//#-end-hidden-code
//: # ProTeGen
//:
//: ## And finally, some differing details
//:
class FourthWorld: World
{
    func generate()
    {
        let water_table = (baseline - variance) + 1
        var ground_level = baseline
        
        for x in 0..<world_width
        {
            let ground_pattern = getGroundLevelOptions(given: ground_level)
            ground_level = chooseFrom(ground_pattern)
            
            for y in 0..<world_height
            {
                world[x, y] = chooseBlock(x, y, ground_level, water_table, biome)
            }
        }
    }
//:
    func makeTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let trunk_height = chooseFrom([(2, 0.3), (3, 0.4), (4, 0.3)])!
        
        for y in y..<(min(y + trunk_height, world.height - 1))
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
    
    func makeTallTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let trunk_height = chooseFrom([(4, 0.3), (5, 0.4), (6, 0.3)])!
        
        for y in y..<(min(y + trunk_height, world.height - 1))
        {
            world[x, y] = wood
        }
        
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunk_height - 1)...(y + trunk_height)
            {
                if valid(x, y) && (world[x, y] == air || world[x, y] == vines || world[x, y]!.collision == .varied)
                {
                    world[x, y] = leaves
                }
            }
        }
        
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunk_height + 1
            
            if valid(x, y) && (world[x, y] == air)
            {
                world[x, y] = leaves
            }
        }
        
        for y in ((y + 2)..<(y + trunk_height)).reversed()
        {
            for x in [x - 2, x + 2]
            {
                if valid(x, y) && (world[x, y] == air || world[x, y]!.collision == .varied)
                {
                    if world[x, y + 1] == bright_leaves
                    {
                        world[x, y] = chooseFrom([(vines, 0.8), (air, 0.2)])
                    } else if world[x, y + 1] == vines {
                        world[x, y] = chooseFrom([(vines, 0.7), (air, 0.3)])
                    }
                }
            }
        }
    }
    
    func makePointedTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let ground_level = y - 1
        
        let trunk_height = chooseFrom([(2, 0.3), (3, 0.3), (4, 0.4)])!
        
        for y in y..<(min(y + trunk_height, world.height - 1))
        {
            world[x, y] = wood
        }
        
        for y in (y + trunk_height - 1)..<(y + trunk_height + 5)
        {
            let width = ((5 + trunk_height) - (y - ground_level)) / 2
            
            for x in (x - width)...(x + width)
            {
                if valid(x, y) && (world[x, y] == air || world[x, y]!.collision == .varied)
                {
                    world[x, y] = leaves
                }
            }
        }
    }
//:
    func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int, _ biome: Biome) -> Block?
    {
        let block = world[x, y]
        let block_below = blockBelow(x, y)
        var options: [(Block, Double)]
        
        if block != air
        {
            return block
        }
        
        if y < ground_level - 2
        {
            options = deep_underground.components
            return chooseFrom(options)
        }
        
        if y < ground_level
        {
            switch biome
            {
                case .normal, .jungle: options = underground.components
                    return chooseFrom(options)
                case .desert: return chooseFrom([(dirt, 0.2), (sand, 0.8)])
                case .snowy: return chooseFrom([(dirt, 0.2), (snow, 0.8)])
            }
        }
        
        if y == ground_level
        {
            if y < water_table
            {
                switch biome
                {
                    case .normal, .jungle, .snowy: return dirt
                    default: break
                }
            }
            
            if surfaceBeside(x, y) == dirt
            {
                switch biome
                {
                    case .normal, .jungle: return grass
                    case .snowy: return snow
                    default: break
                }
            }
            
            switch biome
            {
                case .normal: options = surface.components
                    return chooseFrom(options)
                case .jungle: return chooseFrom([(dirt, 0.3), (grass, 0.7)])
                case .snowy: return chooseFrom([(dirt, 0.2), (snow, 0.8)])
                case .desert: return sand
            }
        }
        
        if y > ground_level
        {
            if y <= water_table
            {
                switch biome
                {
                    case .normal, .jungle: return water
                    case .snowy: return ice
                    default: break
                }
            }
            
            if block_below == dirt
            {
                switch biome
                {
                    case .normal: makeTree(x, y, wood, leaves)
                        return wood
                    case .jungle: makeTallTree(x, y, light_wood, bright_leaves)
                        return light_wood
                    case .snowy: let leaf_block = chooseFrom([(dark_leaves, 0.6), (dry_leaves, 0.4)])!
                        makePointedTree(x, y, wood, leaf_block)
                        return wood
                    default: break
                }
            }
            
            if block_below == grass
            {
                switch biome
                {
                    case .normal: return chooseFrom([(long_grass, 0.2), (air, 0.8)])
                    case .jungle: return chooseFrom([(long_grass, 0.5), (air, 0.5)])
                    default: break
                }
            }
            
            if block_below == sand
            {
                return chooseFrom([(cactus, 0.2), (air, 0.8)])
            }
            
            if block_below == cactus
            {
                if y - ground_level == 2
                {
                    return chooseFrom([(cactus, 0.6), (air, 0.4)])
                }
                
                if y - ground_level == 3
                {
                    return chooseFrom([(cactus, 0.1), (air, 0.9)])
                }
            }
        }
        
        return air
    }
}
//: And once again, we instantiate a world and call it.
let world = FourthWorld(world_width, world_height)
world.generate()
//: [< Features](Features) | [Extras >](Beyond)
//#-hidden-code
let bg: UIImage

switch  biome {
    case .normal: bg = background_color
    case .jungle: bg = jungle_background_color
    case .desert: bg = desert_background_color
    case .snowy: bg = snowy_background_color
}
scene.draw(world, bg)
//#-end-hidden-code
