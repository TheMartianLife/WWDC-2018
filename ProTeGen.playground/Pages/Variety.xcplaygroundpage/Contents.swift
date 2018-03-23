//#-hidden-code
import UIKit

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)
//#-end-hidden-code
//: # ProTeGen
//: So now we know how to generate a world based on the position of each block, but it's not very fun to explore.
//:
//: ## Let's add some variety!
//: To write functions that make the ground level vary, I have defined some values: **baseline** for the y value the ground should average, **variance** for how much it can be above or below this, and **max_step** for how much each ground level can be above or below the one beside it--in this case it is 1 so we can always jump high enough to move forward.
let baseline = 3
let variance = 2
let max_step = 1
//: This is then used by a function called *getGroundLevelOptions* that will return an array of value pairs. Each of these pairs is made up of a number by which the ground level should vary from the last block, and the probability of this being chosen. It would return something like this:
[(-1, 0.2), (0, 0.3), (+1, 0.2)]
//: To make the materials the ground is made up of vary, I have defined a **BlockCategory** type that takes a similar array of value pairs. Each of these pairs is instead made up of a **Block** type and its probability.
let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
//: To make decisions based on these probabilities I have written a function called *chooseFrom()* that takes an array of value-possibility pairs, adds up all the possibilities, generates a random number between them, and returns the value whose range the random number is within. This functionality now makes selection based on weighted probabilities possible for all types.
//:
//: Now we will can the world more advanced, getting more information about each block before making a weighted selection. *generate()* will now put ground blocks up to differing heights...
class SecondWorld: World
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
                world[x, y] = chooseBlock(x, y, ground_level)
            }
        }
    }
//: ...and *chooseBlock()* will decide on different blocks depending on their height in relation to the ground level.
    func chooseBlock(_ x: Int, _ y: Int, _ ground_level: Int) -> Block?
    {
        var options: [(Block, Double)]
        
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
            return grass
        }
        
        return air
    }
}
//: Again, we instantiate a world, and then call it to see the changes we have made.
let world = SecondWorld(world_width, world_height)
world.generate()
//: [< Introduction](Introduction) | [Features >](Features)
//#-hidden-code
scene.draw(world)
//#-end-hidden-code