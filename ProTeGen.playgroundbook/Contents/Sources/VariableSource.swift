import UIKit

// the dimensions for initialising and drawing things
// declaring them here and public made it easier during concept/testing when
// I was changing the world dimensions constantly and making new and bigger textures
public let worldWidth = 16
public let worldHeight = 18
public let textureSize = 160
public let blockSize = 32
public let spriteScale = 1 / CGFloat(textureSize / blockSize)

// the values that define the groundLevelPattern throughout
public let baseline = 3
public let variance = 2
public let maxStep = 1

// the blocks that are used throughout, because it was less work for me and the machine than code-forwarding it through each page to get them everywhere after being declared in their respective pages
// blocks for pages 1 - 3:
public let air = Block()
public let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
public let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
public let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
public let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
public let longGrass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
public let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
public let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
public let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)
// blocks added for pages 4 - 5:
public let apples = Block(texture: UIImage(named: "apples.jpg"), collision: .background)
public let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), collision: .solid)
public let ice = Block(texture: UIImage(named: "ice.jpg"), collision: .solid, opacity: .transparent)
public let darkLeaves = Block(texture: UIImage(named: "dark_leaves.jpg"), collision: .background)
public let dryLeaves = Block(texture: UIImage(named: "dry_leaves.jpg"), collision: .background)
public let icicles = Block(texture: UIImage(named: "icicles.png"), collision: .background)
public let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), collision: .solid)
public let cactus = Block(texture: UIImage(named: "cactus.png"), collision: .background)
public let brightLeaves = Block(texture: UIImage(named: "bright_leaves.jpg"), collision: .background)
public let vines = Block(texture: UIImage(named:"vines.png"), collision: .background)
public let lightWood = Block(texture: UIImage(named: "light_wood.jpg"), collision: .background)

// block categories used before biome-specific values re introduced
// block category for pages 2-5:
public let deepUnderground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
// block categories declared in page 2 that needed using in page 3:
public let underground = BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
public let surface = BlockCategory(components: [(dirt, 0.2), (grass, 0.8)])

