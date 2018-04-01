//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
//#-end-hidden-code
//: # ProTeGen
//: Now we can define the time of day between **.day** and **.night**, which will add or remove sprites that add the night sky and a darkness filter over the scene.
//:
//: ![Visual differences between day and night](page5.jpg)
var time: Time = /*#-editable-code*/.night/*#-end-editable-code*/
let biome: Biome = /*#-editable-code*/.snowy/*#-end-editable-code*/
//: In this page I have also written a simple seed system, using which you can recall a particular world. Given a nil value, it will generate at random as before. Open the viewer beside the random number call to view each seed that is chosen.
func seed()
{
    var seed: Int? = /*#-editable-code*/nil/*#-end-editable-code*/
    
    if seed == nil
    {
        // no seed given, selecting one at random
        seed = Int(arc4random_uniform(1000000000)) // open to see ->
    }

    srand48(seed!)
}
//: ## Extras: beyond what we've done
//: This has been a quick look at a very simple implementation of procedural generation, but there are many ways it could be built on. **Some ideas to explore could be:**
//: * make new types of **Block**s with textures of your own. This could start with some similar to those we have, such as a frozen grass block, and go from there. Clouds might be a fun challenge, let's get you started:
let cloud = Block(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), collision: .background, opacity: .transparent)
//: * make new **BlockCategory** sets, such as a new set of leaves (what was done to randomly placing fruit on trees on the previous page) or "nearWater".
//: * make **Block**s with clever purposes
//:
//: **Some things that could be experimented with in your own implementation of a system like this could be:**
//: * add particle effects. This could be used for things such as making it snow if the world is a snowy biome, or have a random chance of raining in the jungle.
//: * add objects into the scene. An easy way to do this would be instead of using textures as sprites in SceneKit, we could instead draw emojis as sprites. This would enable blocks such as 🌱🌻💎❣️🐛 to be used.
//: * turn it into an infinite runner game, by adding simple input that would move the character sprite and generate new columns for the world on the fly.
//: * investigate ways that more resource-intensive systems implement procedural generation, with the addition of noise functions instead of individual random selectors, or data structures that have better inbuilt knowledge of adjacency instead of our simple array, such as k-d trees.
//:
//: To get the source code for this playground see [ProTeGen on GitHub](https://github.com/TheMartianLife/WWDC-2018).
//:
//: ## Try for yourself: make your mark on everything!
//: Below is an optional free-play area containing the code from the previous page to explore and personalise to your heart's content.
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
    
    func makeCloud(_ x: Int, _ y: Int)
    {
        // have a go yourself at defining how a cloud should be drawn
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
            //=================================================
            // CHANGE PROBABILITIES IN THIS SECTION TO MAKE CLOUDS
            case worldHeight - 1:
                let makeCloudHere = chooseFrom([(true, 0.0), (false, 1.0)])
                if makeCloudHere
                {
                    makeCloud(x, y)
                    return cloud
                }
            //=================================================
            
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
//: We are at the end. I hope you enjoyed this quick look at procedural generation, and that it added to your appreciation of the topic in some way. Thanks for reading!
//:
//: [< Details](Details) | [Start again >>](Introduction)
//#-hidden-code
scene.draw(world, biome, time)

if (biome == .jungle || biome == .normal) && time == .night
{
    playSound("night")
} else {
    playSound(biome.soundFile)
}
//#-end-hidden-code
