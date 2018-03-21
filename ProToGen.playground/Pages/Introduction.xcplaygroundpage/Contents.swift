//#-hidden-code
import UIKit

let world_width = 16
let world_height = 10
let scale = 30
let texture_size = 4

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)
//#-end-hidden-code
//: # ProTeGen
//: We're going to look at a simple implementation of **Pro**cedural **Te**rrain **Gen**eration, using a small, infinitely-scrolling 2D world. All display settings have been predefined, along with a character that can move around, but all aspects of creating the world to explore will be done in the following pages. Using only what you know about arrays and random numbers, we step through:
//:
//: * [**Introduction**](): initial representation of the world
//: * [**Details**](Details): non-uniformity in the terrain
//: * [**Features**](Features): generating features based on position or certain conditions
//: * [**Variety**](Variety): generating features based on other features
//: * [**Beyond**](Beyond): ideas for future actitivities
//:
//: Let's begin!
//: ## First, let's make a world
let air = Block()
let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)
let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), texture: UIImage(named: "snow.jpg"), collision: .solid)
let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), collision: .solid)
//:
class FirstWorld: World {
    
    override func generate()
    {
        for x in 0..<self.width
        {
            for y in 0..<self.height
            {
                self[x, y] = chooseBlock(x, y)
            }
        }
    }
    
    override func chooseBlock(_ x: Int, _ y: Int) -> Block? {
        if y == 0
        {
            return dirt
        }
        
        return air
    }
}

let world = FirstWorld(world_width, world_height)
//: ...and call it to see the world we have made.
//generateWorld()
world.generate()
scene.draw(world)
//: [< Extras](Beyond) | [Details >](Details)
