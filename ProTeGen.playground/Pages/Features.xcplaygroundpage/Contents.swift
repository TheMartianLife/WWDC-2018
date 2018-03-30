//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
srand48(139568022)
//#-end-hidden-code
//: # ProTeGen
//: After making the ground, we need things to put on it.
//: ## Now, some features
//: These next blocks are different to those we have defined before: new collision types are **transparent**, which will appear in front of the character but be partially transparent, and **varied** which will will select at random on a by-block basis whether to appear in front of or behind the character.
let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)
let longGrass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
let greenery = BlockCategory(components: [(longGrass, 0.2), (air, 0.8)])
//: This world gets more complicated again. *generate()* now has the concept of a **waterTable**, a height below which any air blocks should instead be water.
let waterLevel = /*#-editable-code*/1/*#-end-editable-code*/
let waterTable = (baseline - variance) + waterLevel
//: Again, we need a function to generate the world, picking a block for each position.
extension World: Generatable
{
    public func generate()
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
//:
//: ![What a tree will look like](page3.jpg)
    func makeTree(_ x: Int, _ y: Int)
    {
        let trunkHeight = chooseFrom([(2, 0.3), (3, 0.4), (4, 0.3)])
        
        // place wood in a vertical line upwards to the chosen trunk height
        for y in y..<(min(y + trunkHeight, worldHeight - 1))
        {
            self[x, y] = wood
        }
        
        // place leaves in a rectangle 2 blocks each way horizontally and 1 block each way vertically, from the top of the trunk
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunkHeight - 1)...(y + trunkHeight + 1)
            {
                if unoccupied(x, y)
                {
                    self[x, y] = leaves
                }
            }
        }
        
        // place leaves in a row 1 block each way horizontally from the trunk, on top of the other rectangle
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunkHeight + 2
            
            if unoccupied(x, y)
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
        
        switch y
        {
            // below ground by a lot
            case ..<(groundLevel - 2):
                options = deepUnderground.components
                return chooseFrom(options)
            
            // below ground by a little
            case ..<(groundLevel):
                options = underground.components
                return chooseFrom(options)
            
            // above ground
            case (groundLevel + 1)...:
                // if you're below or at the water table, be water
                if y <= waterTable
                {
                    return water
                }
                
                // if you're on top of a block of dirt, place a tree
                if below == dirt
                {
                    makeTree(x, y)
                    return wood
                }
                
                // if you're on top of a block of grass, maybe be long grass
                if below == grass
                {
                    options = greenery.components
                    return chooseFrom(options)
                }
            
            // at ground
            case groundLevel:
                    // if the block above you will be water, don't be grass
                    if y < waterTable
                    {
                        return dirt
                    }
                    
                    // if the block beside you will have a tree on it, don't be the same
                    if surfaceBeside(x, y) == dirt
                    {
                        return grass
                    }
                    
                    // otherwise choose at random like previously
                    options = surface.components
                    return chooseFrom(options)
            
            // the rest of the world
            default: break
        }
        
        return air
    }
}
//: Again, we instantiate and call to generate it.
let world = World(worldWidth, worldHeight)
world.generate()
//: [< Variety](Variety) | [Details >](Details)
//#-hidden-code
scene.draw(world, Biome.normal)
//#-end-hidden-code
