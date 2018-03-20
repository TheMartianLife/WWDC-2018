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
let grass = Block(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(color: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(color: #colorLiteral(red: 0.1937262056, green: 0.1253115404, blue: 0.05571718726, alpha: 1), texture: UIImage(named: ""), collision: .background)
let leaves = Block(color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), texture: UIImage(named: ""), collision: .foreground, opacity: .transparent)
let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), texture: UIImage(named: "snow.jpg"), collision: .solid)
let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), texture: UIImage(named: ""), collision: .solid)
//:
func chooseBlock(_ x: Int, _ y: Int) -> Block? {
    if y == 0
    {
        return dirt
    }
    
    return air
}
//:
func generateWorld()
{
    let world = World(world_width, world_height)
    
    for x in 0..<world_width
    {
        for y in 0..<world_height
        {
            world[x, y] = chooseBlock(x, y)
        }
    }
    scene.draw(world)
}
//: ...and call it to see the world we have made.
generateWorld()
//: [< Extras](Beyond) | [Details >](Details)
