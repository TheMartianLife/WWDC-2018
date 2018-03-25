//#-hidden-code
import UIKit

let ground_level = 0 // CHANGE THIS WITH USER INPUT (0...(world_height - 2))

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)
//#-end-hidden-code
//: # ProTeGen
//: We're going to look at a simple implementation of **Pro**cedural **Te**rrain **Gen**eration, using a small, infinitely-scrolling 2D world. All settings for *drawing* the world have been predefined, along with a character that can move around, but all aspects of creating the world to explore will be done in the following pages. Using only what you know about arrays and random numbers, we step through:
//:
//: * [**Introduction**](): initial representation of the world
//: * [**Variety**](Variety): non-uniformity in the terrain
//: * [**Features**](Features): generating features based on position or certain conditions
//: * [**Details**](Details): generating features based on other features
//: * [**Beyond**](Beyond): ideas for future actitivities
//:
//: Let's begin!
//: ## First, let's make a world
//: I have defined a **Block** type that takes: a *color* or a *texture*, a *collision* type and an optional *opacity*. The first parameter defines how the block will look in the scene, the next defines whether the player character should appear in front of it, behind it, or on top of/appear to collide with it. The last parameter is included for blocks that such as water, where the character should be able to be seen through it.
let air = Block()
let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)
//: Then we need a something to put them in. I have defined a **World** type that acts as a grid of **Block**s, being able to get or set the value of each. Here we extend it with new functions that tell it how to place blocks within the world when it is created.
//:
//:The first is called *generate()*: for each block in the grid it calls another function called *chooseBlock()* that will decide what it should be.
class FirstWorld: World
{
    func generate()
    {
        for x in 0..<world.width
        {
            for y in 0..<world.height
            {
                world[x, y] = chooseBlock(x, y)
            }
        }
    }
//: Then *chooseBlock()* does the work. In this first case, we will start simple: if the block is at the bottom of the world it should be dirt, otherwise it should be air (sky).
    func chooseBlock(_ x: Int, _ y: Int) -> Block? {
        if y == ground_level
        {
            return dirt
        }
        
        return air
    }
}
//: So we instantiate a world with these behaviors...
let world = FirstWorld(world_width, world_height)
//: ...and call it to see the world we have made.
world.generate()
//: [< Extras](Beyond) | [Variety >](Variety)
//#-hidden-code
scene.draw(world, background_color)
//#-end-hidden-code
