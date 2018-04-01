//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
srand48(563830311)
//#-end-hidden-code
/*:
# ProTeGen
## Let's add some variety!
To make the ground level vary, I have written a function called `getGroundLevelOptions()` that will return an array of value pairs. Each of these pairs is made up of a number by which the ground level should vary from the last block, and the probability of this being chosen. It calculates the probability that each possibility should occur, based on variables we will discuss at the bottom of the page, and returns something like this:*/
[
    (heightVariance: -1, probability: 0.2),
    (heightVariance: 0, probability: 0.3),
    (heightVariance: +1, probability: 0.2)
]
//: To make the materials the ground is made up of vary, I have declared some new block types. Then I have defined a `BlockCategory` type that stores similar arrays of value-probability pairs. The **value**s in this case are instead `Block` types to choose from.
let grass = Block(texture: #imageLiteral(resourceName: "grass.jpg"), collision: .solid)
let stone = Block(texture: #imageLiteral(resourceName: "stone.jpg"), collision: .solid)
let bedrock = Block(texture: #imageLiteral(resourceName: "bedrock.jpg"), collision: .solid)

let deepUnderground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
let underground = BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
/*:
 To make decisions based on these probabilities I have written a function called `chooseFrom()` that takes an array of value-possibility pairs, adds up all the possibilities, generates a random number between them, and returns the value whose range the random number is within. This functionality now makes selection based on weighted probabilities possible for all types.

Now we will can the world more advanced, getting more information about each block before making a weighted selection. `generate()` will now put ground blocks up to differing heights...*/
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
                self[x, y] = chooseBlock(x, y, groundLevel)
            }
        }
    }
//: ...and `chooseBlock()` will decide on different block types depending on their height in relation to the `groundLevel`.
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
            
            // otherwise, be air
            default:
                return air
        }
    }
}
/*:
- Experiment:
 *The* `getGroundLevelOptions()` *function calculates what each level's probability should be based on three values:* `baseline`,* `variance`, and* `maxStep`. *Change these values and* **tap "Run My Code" to see the differences**
 */
// the y value the ground should average
let baseline = /*#-editable-code*/3/*#-end-editable-code*/

// how much the ground can be above or below the baseline
let variance = /*#-editable-code*/2/*#-end-editable-code*/

// how much the ground can be above or below the ground beside it
let maxStep = /*#-editable-code*/1/*#-end-editable-code*/
// in a game you would want to keep this low, to ensure the player could always jump high enough to move forward 
/*:
- Note:
**Note that this time there will be a button in the scene that will generate a new world each time it is tapped, based on existing settings. This demonstrates how different each world can be despite being made from the same code.**
 
![What the regenerate button looks like](buttonexample.jpg)
 */
let world = World(worldWidth, worldHeight, baseline, variance, maxStep)
world.generate()
//: Let's move onto adding some [features](Features).
//#-hidden-code
scene.draw(world)
playSound("cold")
//#-end-hidden-code
