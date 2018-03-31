import UIKit

public enum Biome
{
    case normal
    case desert
    case jungle
    case snowy
    
    var backgroundColor: UIColor
    {
        switch self
        {
            case .normal:   return UIColor(red: 0.569, green: 0.898, blue: 1, alpha: 1)
            case .desert:   return UIColor(red: 0.682, green: 0.855, blue: 0.851, alpha: 1)
            case .jungle:   return UIColor(red: 0.765, green: 0.976, blue: 0.969, alpha: 1)
            case .snowy:    return UIColor(red: 0.678, green: 0.8, blue: 87.1, alpha: 1)
        }
    }
    
    var backgroundImage: UIImage
    {
        switch self
        {
            case .normal:   return UIImage(named: "background_color.jpg")!
            case .desert:   return UIImage(named: "desert_background_color.jpg")!
            case .jungle:   return UIImage(named: "jungle_background_color.jpg")!
            case .snowy:    return UIImage(named: "snowy_background_color.jpg")!
        }
    }
    
    var soundFile: String
    {
        switch self
        {
            case .normal:   return "forest"
            case .desert:   return "wind"
            case .jungle:   return "jungle"
            case .snowy:    return "wind"
        }
    }
    
    public var underground: BlockCategory
    {
        switch self
        {
            case .normal:   return BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
            case .desert:   return BlockCategory(components: [(dirt, 0.2), (sand, 0.8)])
            case .jungle:   return BlockCategory(components: [(stone, 0.2), (dirt, 0.8)])
            case .snowy:    return BlockCategory(components: [(dirt, 0.2), (snow, 0.8)])
        }
    }
    
    public var surface: BlockCategory
    {
        switch self
        {
            case .normal:   return BlockCategory(components: [(dirt, 0.2), (grass, 0.8)])
            case .desert:   return BlockCategory(components: [(sand, 1.0)])
            case .jungle:   return BlockCategory(components: [(dirt, 0.3), (grass, 0.7)])
            case .snowy:    return BlockCategory(components: [(dirt, 0.2), (snow, 0.8)])
        }
    }
    
    public var greenery: BlockCategory
    {
        switch self
        {
            case .normal:   return BlockCategory(components: [(longGrass, 0.2), (air, 0.8)])
            case .jungle:   return BlockCategory(components: [(longGrass, 0.5), (air, 0.5)])
            case .desert:   return BlockCategory(components: [(cactus, 0.2), (air, 0.8)])
            case .snowy:    return BlockCategory(components: [(air, 1.0)])
        }
    }
}
