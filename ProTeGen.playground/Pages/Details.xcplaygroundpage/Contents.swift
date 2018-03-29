//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight, scale, textureSize)
srand48(Int(arc4random_uniform(1000000000)))
scene.addControls(for: .page4)
//#-end-hidden-code
//: # ProTeGen
//:
//: ## And finally, some differing details
//:
//#-editable-code
let biome = Biome.snowy
//#-end-editable-code
//:
class FourthWorld: World
{
    func generate(with biome: Biome)
    {
        let waterTable = (baseline - variance) + 1
        var groundLevel = baseline
        
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
//:
    func makeTree(_ x: Int, _ y: Int, _ wood: Block, _ leaves: Block)
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
                if unoccupied(x, y)
                {
                    self[x, y] = leaves
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
                if unoccupied(x, y)
                {
                    self[x, y] = leaves
                }
            }
        }
        
        for x in (x - 2)...(x + 2)
        {
            let y = y + trunkHeight - 2
            
            if valid(x, y) && self[x, y] == air && self[x, y + 1] == leaves && (trunkHeight > 2)
            {
                self[x, y ] = chooseFrom([(icicles, 0.4), (air, 0.6)])
            }
        }
    }
//:
    func chooseBlock(_ x: Int, _ y: Int, _ groundLevel: Int, _ waterTable: Int, _ biome: Biome) -> Block
    {
        let block = self[x, y]
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
            switch biome
            {
                case .normal, .jungle: options = underground.components
                    return chooseFrom(options)
                case .desert: return chooseFrom([(dirt, 0.2), (sand, 0.8)])
                case .snowy: return chooseFrom([(dirt, 0.2), (snow, 0.8)])
            }
        }
        
        if y == groundLevel
        {
            if y < waterTable
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
        
        if y > groundLevel
        {
            if y <= waterTable
            {
                switch biome
                {
                    case .normal, .jungle: return water
                    case .snowy: return ice
                    default: break
                }
            }
            
            if below == dirt
            {
                switch biome
                {
                    case .normal: makeTree(x, y, wood, leaves)
                        return wood
                    case .jungle: makeTallTree(x, y, lightWood, brightLeaves)
                        return lightWood
                    case .snowy: let leafBlock = chooseFrom([(darkLeaves, 0.6), (dryLeaves, 0.4)])
                        makePointedTree(x, y, wood, leafBlock)
                        return wood
                    default: break
                }
            }
            
            if below == grass
            {
                switch biome
                {
                    case .normal: return chooseFrom([(longGrass, 0.2), (air, 0.8)])
                    case .jungle: return chooseFrom([(longGrass, 0.5), (air, 0.5)])
                    default: break
                }
            }
            
            if below == sand
            {
                return chooseFrom([(cactus, 0.2), (air, 0.8)])
            }
            
            if below == cactus
            {
                if y - groundLevel == 2
                {
                    return chooseFrom([(cactus, 0.6), (air, 0.4)])
                }
                
                if y - groundLevel == 3
                {
                    return chooseFrom([(cactus, 0.1), (air, 0.9)])
                }
            }
        }
        
        return air
    }
}
//: And once again, we instantiate a world and call it.
let world = FourthWorld(worldWidth, worldHeight)
world.generate(with: biome)
//: [< Features](Features) | [Extras >](Beyond)
//#-hidden-code
let bg: UIImage
let sound: String

switch  biome {
    case .normal: bg = backgroundColor
        sound = forestSound
    case .jungle: bg = jungleBackgroundColor
        sound = jungleSound
    case .desert: bg = desertBackgroundColor
        sound = windSound
    case .snowy: bg = snowyBackgroundColor
        sound = windSound
}

scene.draw(world, bg)
//playSound(sound)
//#-end-hidden-code
