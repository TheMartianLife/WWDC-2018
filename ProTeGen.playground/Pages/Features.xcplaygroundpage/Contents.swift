//#-hidden-code
// BETTER WATER
// SURFACE DETAILS
import UIKit

let water_table = (baseline - variance) + 1 // CHANGE WITH USER INPUT

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)
//#-end-hidden-code
//: # ProTeGen
//: After making the ground, we need things to put on it.
//: ## Now, some features
//: This next type of block is different to those we have defined before: its texture is partially transparent, making it not block-shaped, and it introduces a fourth collision type. This type means each occurence of it will appear either in front of or behind the character at random.
let long_grass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
//: This world gets more complicated again. *generate()* now has the concept of a **water_table**, a height below which any air blocks should instead be water.
class ThirdWorld: World
{
    func generate()
    {
        var ground_level = baseline
        
        for x in 0..<world_width
        {
            let ground_pattern = getGroundLevelOptions(given: ground_level)
            ground_level = chooseFrom(ground_pattern)
            
            for y in 0..<world_height
            {
                world[x, y] = chooseBlock(x, y, ground_level, water_table)
            }
        }
    }
//: A new function in this world is called *makeTree()*, which takes a position and sets the appropriate blocks around it to be wood and leaves.
    func makeTree(_ x: Int, _ y: Int)
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
//: Now the *chooseBlock()* function will place long grass on some grass blocks, place dirt and water on any surface below the water table height, and has the chance to make some normal surface blocks dirt--but no two surface blocks in a row. This is because these dirt blocks then produce trees, and this prevents them appearing side-by-side. To do this, I have given the **World** type functions to find what the block beside, below, or on the surface beside it is.
//:
//: Since the above *makeTree()* function is the first thing to defy our left-to-right generation rule, notice that as the selection moves through the world it will not change any block which was already set before its turn.
    func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int, _ water_table: Int) -> Block?
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
            
            if block_below == grass
            {
                return chooseFrom([(long_grass, 0.2), (air, 0.8)])
            }
        }
        
        return air
    }
}
//: Again, we instantiate a world and call it.
let world = ThirdWorld(world_width, world_height)
world.generate()
//: [< Variety](Variety) | [Details >](Details)
//#-hidden-code
scene.draw(world, background_color)
//#-end-hidden-code
