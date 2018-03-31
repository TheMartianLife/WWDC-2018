import UIKit

public let worldWidth = 16
public let worldHeight = 16
public let textureSize = 160
public let blockSize = 32
public let spriteScale = 1 / CGFloat(textureSize / blockSize)

public let baseline = 3
public let variance = 2
public let maxStep = 1

public let air = Block()
public let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
public let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
public let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
public let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
public let longGrass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
public let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
public let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
public let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)

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

public let deepUnderground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])

