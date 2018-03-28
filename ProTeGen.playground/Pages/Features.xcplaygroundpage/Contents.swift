//#-hidden-code
// BETTER WATER
// SURFACE DETAILS
import UIKit

let scene = Scene(worldWidth, worldHeight, scale, textureSize)
scene.addControls(for: .page3)
//#-end-hidden-code
//: # ProTeGen
//: After making the ground, we need things to put on it.
//: ## Now, some features
//: This next type of block is different to those we have defined before: its texture is partially transparent, making it not block-shaped, and it introduces a fourth collision type. This type means each occurence of it will appear either in front of or behind the character at random.
let longGrass = Block(texture: #imageLiteral(resourceName: "long_grass.png"), collision: .varied)
let greenery = BlockCategory(components: [(longGrass, 0.2), (air, 0.8)])
//: This world gets more complicated again. *generate()* now has the concept of a **waterTable**, a height below which any air blocks should instead be water.
//#-editable-code
let waterLevel = 1
let waterTable = (baseline - variance) + waterLevel
//#-end-editable-code
//: Again, we need a function to generate the world, picking a block for each position.
class ThirdWorld: World
{
    func generate()
    {
        var groundLevel = baseline
        
        for x in 0..<worldWidth
        {
            let groundPattern = getGroundLevelOptions(given: groundLevel)
            groundLevel = chooseFrom(groundPattern)
            
            for y in 0..<worldHeight
            {
                self[x, y] = chooseBlock(x, y, groundLevel, waterTable)
            }
        }
    }
//: A new function in this world is called *makeTree()*, which takes a position and sets the appropriate blocks around it to be wood and leaves.
    func makeTree(_ x: Int, _ y: Int)
    {
        let trunkHeight = chooseFrom([(2, 0.3), (3, 0.4), (4, 0.3)])
        
        for y in y..<(min(y + trunkHeight, worldHeight - 1))
        {
            self[x, y] = wood
        }
        
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunkHeight - 1)...(y + trunkHeight + 1)
            {
                if valid(x, y) && (self[x, y] == air || self[x, y].collision == .varied)
                {
                    self[x, y] = leaves
                }
            }
        }
        
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunkHeight + 2
            
            if valid(x, y) && (self[x, y] == air)
            {
                self[x, y] = leaves
            }
        }
    }
//: Now the *chooseBlock()* function will place long grass on some grass blocks, place dirt and water on any surface below the water table height, and has the chance to make some normal surface blocks dirt--but no two surface blocks in a row. This is because these dirt blocks then produce trees, and this prevents them appearing side-by-side. To do this, I have given the **World** type functions to find what the block beside, below, or on the surface beside it is.
//:
//: Since the above *makeTree()* function is the first thing to defy our left-to-right generation rule, notice that as the selection moves through the world it will not change any block which was already set before its turn.
    func chooseBlock(_ x: Int, _ y: Int, _ groundLevel: Int, _ waterTable: Int) -> Block
    {
        let block = world[x, y]
        let below = blockBelow(x, y)
        var options: [(Block, Double)]
        
        if block != air
        {
            return block
        }
        
        if y < groundLevel - 2
        {
            options = deepUnderground.components
            return chooseFrom(options)
        }
        
        if y < groundLevel
        {
            options = underground.components
            return chooseFrom(options)
        }
        
        if y == groundLevel
        {
            if y < waterTable
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
        
        if y > groundLevel
        {
            if y <= waterTable
            {
                return water
            }
            
            if below == dirt
            {
                makeTree(x, y)
                return wood
            }
            
            if below == grass
            {
                options = greenery.components
                return chooseFrom(options)
            }
        }
        
        return air
    }
}
//: Again, we instantiate and call to generate it.
let world = ThirdWorld(worldWidth, worldHeight)
world.generate()
//: [< Variety](Variety) | [Details >](Details)
//#-hidden-code
scene.draw(world, backgroundColor)
scene.addControls(for: .page3)
playSound(forestSound)

//#-end-hidden-code
