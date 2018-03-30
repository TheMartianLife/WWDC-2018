//#-hidden-code
import UIKit

let scene = Scene(worldWidth, worldHeight)
//#-end-hidden-code
//: # ProTeGen
//: ...
//: ## Bring it all together
//: ...
// dictate the ground level
let baseline = /*#-editable-code*/3/*#-end-editable-code*/
let variance = /*#-editable-code*/2/*#-end-editable-code*/
let maxStep = /*#-editable-code*/1/*#-end-editable-code*/

// dictate the water level
let waterLevel = /*#-editable-code*/1/*#-end-editable-code*/
let waterTable = (baseline - variance) + waterLevel

// dictate the biome
let biome = Biome/*#-editable-code*/.snowy/*#-end-editable-code*/
//: ## Extras: beyond what we've done
//:
//: ![Visual differences between day and night](page5.jpg)
var time = Time/*#-editable-code*/.day/*#-end-editable-code*/





//: In this page I have also written a simple seed system, using which you can recall a particular world. Given a nil value, it will generate at random as before.
var seed: Int? = /*#-editable-code*/nil/*#-end-editable-code*/

if seed == nil
{
    seed = Int(arc4random_uniform(1000000000))
    print("No seed given, selecting one at random.")
}

print("World seed: \(seed!)")
srand48(seed!)
//:
//#-editable-code

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

//#-end-editable-code
//: ...and generate a final world containing all the excellent things you have made.
//world.generate()
// better ways to make things (noise, kd-trees)
//: [< Details](Details) | [Start again >>](Introduction)
//#-hidden-code
//scene.draw(world, biome, time)
//#-end-hidden-code
