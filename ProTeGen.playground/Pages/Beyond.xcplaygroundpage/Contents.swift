//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
//#-end-hidden-code
//: # ProTeGen
//: ...
//: ## Extras: beyond what we've done
//:
//:
// other blocks
//let cloud =  Block(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), texture: UIImage(named: ""), collision: .background)

// other blocks with clever purposes
//let close_leaves = Block(color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), texture: UIImage(named: "leaves.jpg"), collision: .foreground)
// lava? => death condition

// other block categories
// near water?

// other types of objects (not blocks)
// - emoji? 🌱🌻💎❣️ animals?
// let sapling = 🌱
// let flower = 🌻
// let
// let plants = ItemCategory(components: [( , )])
// better ways to make things (noise, kd-trees)
//: ![Visual differences between day and night](page5.jpg)
var time = Time/*#-editable-code*/.night/*#-end-editable-code*/
let biome = Biome/*#-editable-code*/.snowy/*#-end-editable-code*/
//: In this page I have also written a simple seed system, using which you can recall a particular world. Given a nil value, it will generate at random as before.
func seed()
{
    var seed: Int? = /*#-editable-code*/nil/*#-end-editable-code*/
    
    if seed == nil
    {
        print("No seed given, selecting one at random.")
        seed = Int(arc4random_uniform(1000000000))
    }
    
    print("World seed: \(seed!)")
    srand48(seed!)
}
//: ## Try for yourself!
//#-editable-code
// make some new blocks if you like!
//#-end-editable-code
extension World: Generatable
{
    public func generate()
    {

        let waterTable = (baseline - variance) + 1
        var groundLevel = baseline
        
        seed() // now calls the seed system
        
        for x in 0..<worldWidth
        {
            let groundPattern = getGroundLevelOptions(given: groundLevel)
            groundLevel = chooseFrom(groundPattern)
            
            for y in 0..<worldHeight
            {
                self[x, y] = chooseBlock(x, y, groundLevel, waterTable, biome)
            }
        }
    }
    //: Then experiment with total freedom...
    //#-editable-code
    func makeTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let appleTree = chooseFrom([(true, 0.3), (false, 0.7)])
        let trunkHeight = chooseFrom([(2, 0.3), (3, 0.4), (4, 0.3)])
        
        for y in y..<(min(y + trunkHeight, worldHeight - 1))
        {
            self[x, y] = wood
        }
        
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunkHeight - 1)...(y + trunkHeight + 1)
            {
                if unoccupied(x, y)
                {
                    if appleTree
                    {
                        let blocks: [(Block, Double)] = [(apples, 0.3), (leaves, 0.7)]
                        self[x, y] = chooseFrom(blocks)
                    } else {
                        self[x, y] = leaves
                    }
                }
            }
        }
        
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunkHeight + 2
            
            if unoccupied(x, y)
            {
                self[x, y] = leaves
            }
        }
    }
    
    func makeTallTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let trunkHeight = chooseFrom([(4, 0.3), (5, 0.4), (6, 0.3)])
        
        for y in y..<(min(y + trunkHeight, worldHeight - 1))
        {
            self[x, y] = wood
        }
        
        for x in (x - 2)...(x + 2)
        {
            for y in (y + trunkHeight - 1)...(y + trunkHeight)
            {
                if unoccupied(x, y) || self[x, y] == vines
                {
                    self[x, y] = leaves
                }
            }
        }
        
        for x in (x - 1)...(x + 1)
        {
            let y = y + trunkHeight + 1
            
            if unoccupied(x, y)
            {
                self[x, y] = leaves
            }
        }
        
        for y in ((y + 2)..<(y + trunkHeight)).reversed()
        {
            for x in [x - 2, x + 2]
            {
                if unoccupied(x, y)
                {
                    let above = blockAbove(x, y)
                    
                    switch above
                    {
                    case _ where above == brightLeaves:
                        self[x, y] = chooseFrom([(vines, 0.8), (air, 0.2)])
                        
                    case _ where above == vines:
                        self[x, y] = chooseFrom([(vines, 0.7), (air, 0.3)])
                        
                    default: break
                    }
                }
            }
        }
    }
    
    func makePointedTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
    {
        let groundLevel = y - 1
        
        let trunkHeight = chooseFrom([(2, 0.3), (3, 0.3), (4, 0.4)])
        
        for y in y..<(min(y + trunkHeight, worldHeight - 1))
        {
            self[x, y] = wood
        }
        
        for y in (y + trunkHeight - 1)..<(y + trunkHeight + 5)
        {
            let width = ((5 + trunkHeight) - (y - groundLevel)) / 2
            
            for x in (x - width)...(x + width)
            {
                if unoccupied(x, y) || self[x, y] == icicles
                {
                    self[x, y] = leaves
                }
            }
        }
        
        for x in (x - 2)...(x + 2)
        {
            let y = y + trunkHeight - 2
            
            if unoccupied(x, y) && blockAbove(x, y) == leaves && (trunkHeight > 2)
            {
                self[x, y ] = chooseFrom([(icicles, 0.4), (air, 0.6)])
            }
        }
    }

    func chooseBlock(_ x: Int, _ y: Int, _ groundLevel: Int, _ waterTable: Int, _ biome: Biome) -> Block
    {
        let block = self[x, y]
        let below = blockBelow(x, y)
        var options: [(Block, Double)]
        
        // if you've already been given a block, be that
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
            options = biome.underground.components
            return chooseFrom(options)
            
        // above ground
        case (groundLevel + 1)...:
            // if you're below or at the water table, be water or ice
            if y <= waterTable
            {
                switch biome
                {
                case .normal, .jungle: return water
                case .snowy: return ice
                default: break
                }
            }
            
            // if you're on top of a block of dirt, place a tree
            if below == dirt
            {
                switch biome
                {
                case .normal:
                    makeTree(x, y, wood, leaves)
                    return wood
                    
                case .jungle:
                    makeTallTree(x, y, lightWood, brightLeaves)
                    return lightWood
                    
                case .snowy:
                    let leafBlock = chooseFrom([(darkLeaves, 0.6), (dryLeaves, 0.4)])
                    makePointedTree(x, y, wood, leafBlock)
                    return wood
                    
                default: break
                }
            }
            
            // if you're on top of a block of grass, maybe be long grass
            if below == grass || below == sand
            {
                options = biome.greenery.components
                return chooseFrom(options)
            }
            
            // if you're on top of a single cactus, maybe be a second cactus
            if below == cactus && y - groundLevel == 2
            {
                options = [(cactus, 0.7), (air, 0.3)]
                return chooseFrom(options)
            }
            
        // at ground
        case groundLevel:
            // if the block above you will be water or ice, don't be grass
            if y < waterTable
            {
                switch biome
                {
                case .normal, .jungle, .snowy: return dirt
                default: break
                }
            }
            
            // if the block beside you will have a tree on it, don't be the same
            if surfaceBeside(x, y) == dirt
            {
                switch biome
                {
                case .normal, .jungle: return grass
                case .snowy: return snow
                default: break
                }
            }
            
            // otherwise, choose at random like previously
            options = biome.surface.components
            return chooseFrom(options)
            
        // the rest of the world
        default: break
        }
        
        return air
    }
    //#-end-editable-code
}
//: ...and generate a final world containing all the excellent things you have made.
let world = World(worldWidth, worldHeight)
world.generate()
//: [< Details](Details) | [Start again >>](Introduction)
//#-hidden-code
scene.draw(world, biome, time)

if time == .day
{
    playSound(biome.soundFile)
} else {
    playSound("crickets")
}
//#-end-hidden-code
