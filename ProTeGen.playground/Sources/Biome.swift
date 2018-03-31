import UIKit

/**
 Biome type defines look, composition and sound of worlds generated with a certain biome in mind.
 */
public enum Biome
{
    case normal
    case desert
    case jungle
    case snowy
    
    // when drawing the scene, each biome will have a different sky color
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
    
    // default sound for each environment before conditions are considered
    public var soundFile: String
    {
        switch self
        {
            case .normal:   return "forest"
            case .desert:   return "wind"
            case .jungle:   return "jungle"
            case .snowy:    return "wind"
        }
    }
    
    // block compositions for shallow underground
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
    
    // block compositions for at the ground level
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
    
    // block compositions for on top of the ground leve;
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
