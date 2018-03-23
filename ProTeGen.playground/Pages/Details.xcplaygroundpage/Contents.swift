//#-hidden-code
import UIKit

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)

let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
let surface = BlockCategory(components: [(dirt, 0.1), (grass, 0.9)])
/*
public func makeTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
{
    let trunk_height = chooseFrom([(2, 0.3), (3, 0.4), (4, 0.3)])!
    
    for y in y..<(y + trunk_height)
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
}*/
//#-end-hidden-code
//: # ProTeGen
//:
//: ## And finally, some differing details
//:
let normal = Biome(temperature: .moderate, humidity: .moderate)
let desert = Biome(temperature: .hot, humidity: .dry)
let jungle = Biome(temperature: .hot, humidity: .wet)
let snowy = Biome(temperature: .cold, humidity: .moderate)
//:
class FourthWorld: World
{
    func generate()
    {
        let water_table = (baseline - variance) + 1
        var ground_level = baseline
        var biome = normal
        
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
    func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int, _ biome: Biome) -> Block?
    {
        
    }
}
//: And once again, we instantiate a world and call it.
let world = FourthWorld(world_width, world_height)
world.generate()
//: [< Features](Features) | [Extras >](Beyond)
//#-hidden-code
scene.draw(world)
//#-end-hidden-code
