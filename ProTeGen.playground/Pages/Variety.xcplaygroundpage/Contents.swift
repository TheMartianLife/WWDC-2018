//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
srand48(563830311)
//#-end-hidden-code
//: # ProTeGen
//: So now we know how to generate a world based on the position of each block, but it isn't very interesting. It will always look the same and if it were a game it would looks the same forever in either direction.
//:
//: ## Let's add some variety!
//: To write functions that make the ground level vary, I have defined some values: **baseline** for the y value the ground should average, **variance** for how much it can be above or below this, and **maxStep** for how much each ground level can be above or below the one beside it--in this case it is 1 so we can always jump high enough to move forward.
let baseline = /*#-editable-code*/3/*#-end-editable-code*/
let variance = /*#-editable-code*/2/*#-end-editable-code*/
let maxStep = /*#-editable-code*/1/*#-end-editable-code*/
//: This is then used by a function called *getGroundLevelOptions* that will return an array of value pairs. Each of these pairs is made up of a number by which the ground level should vary from the last block, and the probability of this being chosen. It would return something like this:
[(-1, 0.2), (0, 0.3), (+1, 0.2)]
//: To make the materials the ground is made up of vary, I have declared some new block types. Then I have defined a **BlockCategory** type that takes a similar array of value pairs. Each of these pairs is instead made up of a **Block** type and its probability.
let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)

let deepUnderground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
//: To make decisions based on these probabilities I have written a function called *chooseFrom()* that takes an array of value-possibility pairs, adds up all the possibilities, generates a random number between them, and returns the value whose range the random number is within. This functionality now makes selection based on weighted probabilities possible for all types.
//:
//: Now we will can the world more advanced, getting more information about each block before making a weighted selection. *generate()* will now put ground blocks up to differing heights...
extension World: Generatable
{
    public func generate()
    {
        var groundLevel = baseline
        
        for x in 0..<worldWidth
        {
            let groundPattern = getGroundLevelOptions(given: groundLevel, baseline, variance, maxStep)
            groundLevel = chooseFrom(groundPattern)
            
            for y in 0..<worldHeight
            {
                self[x, y] = chooseBlock(x, y, groundLevel)
            }
        }
    }
//: ...and *chooseBlock()* will decide on different blocks depending on their height in relation to the ground level.
    func chooseBlock(_ x: Int, _ y: Int, _ groundLevel: Int) -> Block
    {
        let options: [(Block, Double)]
        
        switch y
        {
            // if you're the ground surface then be grass
            case groundLevel:
                return grass
            
            // if you're below ground level by up to 2 blocks, be a block that would appear underground
            case (groundLevel - 2)..<groundLevel:
                options = underground.components
                return chooseFrom(options)
            
            // if you're more than 2 blocks underground, be a block that would appear deep underground
            case ..<(groundLevel - 2):
                options = deepUnderground.components
                return chooseFrom(options)
            
            // else, be air
            default:
                return air
        }
    }
}
//: Again, we instantiate a world, and then call it to see the changes we have made.
let world = World(worldWidth, worldHeight)
world.generate()
//: [< Introduction](Introduction) | [Features >](Features)
//#-hidden-code
scene.draw(world, Biome.desert)
//#-end-hidden-code
