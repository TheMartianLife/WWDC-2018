//#-hidden-code
import UIKit

let scene = Scene(world_width, world_height, scale, texture_size)
//#-end-hidden-code
//: # ProTeGen
//:
//: ## Extras: beyond what we've done
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
//: ...and generate a final world containing all the excellent things you have made.
// generateWorld()
// better ways to make things (noise, kd-trees)
//: [< Details](Details) | [Start again >>](Introduction)
//#-hidden-code
//scene.addControls(for: .page5)
//#-end-hidden-code
