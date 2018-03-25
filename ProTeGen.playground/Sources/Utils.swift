import Foundation
import UIKit

public let world_width = 16
public let world_height = 16
public let scale = 30
public let texture_size = 4

public let baseline = 3
public let variance = 2
public let max_step = 1

public let background_color = UIImage(named: "background_color.jpg")!
public let desert_background_color = UIImage(named: "desert_background_color.jpg")!
public let jungle_background_color = UIImage(named: "jungle_background_color.jpg")!
public let snowy_background_color = UIImage(named: "snowy_background_color.jpg")!

public let air = Block()
public let grass = Block(texture: UIImage(named: "grass.jpg"), collision: .solid)
public let dirt = Block(texture: UIImage(named: "dirt.jpg"), collision: .solid)
public let stone = Block(texture: UIImage(named: "stone.jpg"), collision: .solid)
public let bedrock = Block(texture: UIImage(named: "bedrock.jpg"), collision: .solid)
public let long_grass = Block(texture: UIImage(named: "long_grass.png"), collision: .varied)
public let wood = Block(texture: UIImage(named: "wood.jpg"), collision: .background)
public let leaves = Block(texture: UIImage(named: "leaves.jpg"), collision: .background)
public let water = Block(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), collision: .foreground, opacity: .transparent)

public let snow = Block(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), collision: .solid)
public let ice = Block(texture: UIImage(named: "ice.jpg"), collision: .solid, opacity: .transparent)
public let dark_leaves = Block(texture: UIImage(named: "dark_leaves.jpg"), collision: .background)
public let dry_leaves = Block(texture: UIImage(named: "dry_leaves.jpg"), collision: .background)

public let sand =  Block(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), collision: .solid)
public let cactus = Block(texture: UIImage(named: "cactus.png"), collision: .background)

public let bright_leaves = Block(texture: UIImage(named: "bright_leaves.jpg"), collision: .background)
public let vines = Block(texture: UIImage(named:"vines.png"), collision: .background)
public let light_wood = Block(texture: UIImage(named: "light_wood.jpg"), collision: .background)

public let deep_underground = BlockCategory(components: [(bedrock, 0.3), (stone, 0.6), (dirt, 0.1)])
public let underground = BlockCategory(components: [(stone, 0.1), (dirt, 0.9)])
public let surface = BlockCategory(components: [(dirt, 0.2), (grass, 0.8)])

public func getGroundLevelOptions(given prev: Int) -> [(Int, Double)]
{
    var pattern_array: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((max_step + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        pattern_array.append((x, probability))
    }
    
    return pattern_array
}

public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T!
{
    let total_probability = options.reduce(0, { $0 +  $1.probability }) * 100
    let random_selector = Double(arc4random_uniform(UInt32(total_probability))) / 100.0
    var cumulative_probability = 0.0
    
    for item in options
    {
        cumulative_probability += item.probability
        
        if random_selector < cumulative_probability
        {
            return item.value
        }
    }
    
    if let highest_probability = options.max(by: { $0.probability < $1.probability })
    {
        return highest_probability.value
    }
    
    return nil
}
