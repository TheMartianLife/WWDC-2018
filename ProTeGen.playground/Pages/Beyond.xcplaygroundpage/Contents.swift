//#-hidden-code
import UIKit

let world_width = 10
let world_height = 8
let scale = 30
let texture_size = 4

let scene = Scene(world_width: world_width, world_height: world_height, scale: scale, texture_size: texture_size)
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

// other biomes for smooth transitions between
// - block layers (draw two textures over each other w/ opacity)

// other types of objects (not blocks)
// - emoji? 🌱🌻💎❣️ animals?
// let sapling = 🌱
// let flower = 🌻
// let
// let plants = ItemCategory(components: [( , )])
//: ...and generate a final world containing all the excellent things you have made.
// generateWorld()
// better ways to make things (noise, kd-trees)

//: [< Variety](Variety) | [Start again >>](Introduction)
