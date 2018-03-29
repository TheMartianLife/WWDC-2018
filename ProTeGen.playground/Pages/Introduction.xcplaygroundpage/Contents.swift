//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight, scale, textureSize)
//#-end-hidden-code
//: # ProTeGen
//: We're going to look at a simple implementation of **Pro**cedural **Te**rrain **Gen**eration, using a small 2D world and Swift's **SpriteKit**. Using this method, it's possible to make games or scenes with virtually inifinite dimensions and variation. In this case, we start small; but the concepts are much the same even in worlds much larger, more complex, or in three dimensions.
//:
//: All settings for *drawing* the world and character have been done for you, simply drawing sprites to the scene based on their position in the underlying world data, but all aspects of what the world will contain will be done in the following pages. Using only what you know about arrays and random numbers, we step through:
//:
//: * [**Introduction**](): initial representation of the world
//: * [**Variety**](Variety): non-uniformity in the terrain
//: * [**Features**](Features): generating features based on position or certain conditions
//: * [**Details**](Details): generating features based on other features
//: * [**Beyond**](Beyond): ideas for future activities
//:
//: Let's begin!
//: ## First, let's make a world
//: I have defined a **Block** type that takes: a *color* or a *texture*, AND a *collision* type. The first parameter defines how the block will look in the scene, the next defines whether the player character should appear in front of or behind it and will later decide how they collide with others.
let air = Block(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), collision: .none)
let dirt = Block(texture: #imageLiteral(resourceName: "dirt.jpg"), collision: .solid)
//: Then we need a something to put them in. I have defined a **World** type that acts as a grid of **Block**s, being able to get or set the value of each. Here we extend it with new functions that tell it how to place blocks within the world when it is created.
//:
//:The first is called *generate()*: for each block in the grid it calls another function called *chooseBlock()* that will decide what it should be.
class FirstWorld: World
{
    func generate()
    {
        for x in 0..<worldWidth
        {
            for y in 0..<worldHeight
            {
                self[x, y] = chooseBlock(x, y)
            }
        }
    }
//: Then *chooseBlock()* does the work. In this first case, we will start simple...
    func chooseBlock(_ x: Int, _ y: Int) -> Block
    {
        // if you're at or below ground level, be ground
        if y <= groundLevel
        {
            return dirt
        }
        
        // otherwise be air
        return air
    }
}
//: To change where the ground is drawn, you can simply change the value used in the rule. Here, zero means only the bottom row.
let groundLevel = /*#-editable-code*/0/*#-end-editable-code*/
//: Then we instantiate and generate the world to see what we have made.
let world = FirstWorld(worldWidth, worldHeight)
world.generate()
//: [< Extras](Beyond) | [Variety >](Variety)
//#-hidden-code
scene.draw(world, backgroundColor)
scene.addControls(for: .page1)
//playSound(windSound)
//#-end-hidden-code
