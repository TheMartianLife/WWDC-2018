import UIKit

public let worldWidth = 16
public let worldHeight = 16
public let scale = 30
public let textureSize = 4

public let baseline = 3
public let variance = 2
public let maxStep = 1

public let windSound = "wind"
public let forestSound = "forest"
public let jungleSound = "jungle"
public let waterSound = "water"
public let nightSound = "crickets"

public let backgroundColor = UIImage(named: "background_color.jpg")!
public let desertBackgroundColor = UIImage(named: "desert_background_color.jpg")!
public let jungleBackgroundColor = UIImage(named: "jungle_background_color.jpg")!
public let snowyBackgroundColor = UIImage(named: "snowy_background_color.jpg")!

public let air = Block(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), collision: .none)
public let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
public let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
public let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
public let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
public let longGrass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
public let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
public let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
public let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)

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
public let underground = BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
public let surface = BlockCategory(components: [(dirt, 0.2), (grass, 0.8)])

