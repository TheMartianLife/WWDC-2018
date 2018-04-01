import UIKit

/**
 Collision type defines how sprites are drawn in relation to character, and how they will take precedence over the selection of blocks around them.
 */
public enum CollisionType
{
    case solid // at character (character collides), overrides all others
    case background // behind character, will override .varied blocks
    case foreground // in front of character
    case varied // behind or in front of character, at random
    case none // air (is not drawn)
}

/**
 Opacity type defines how sprites are drawn, namely whether or not a character will be seen through them if drawn in the foreground.
 */
public enum Opacity
{
    case opaque // not see-through
    case transparent // see-through
}

/**
 BlockCategory type is a neat way to declare the (value, probability) arrays that are used to select blocks in pages 2 - 5.
 */
public struct BlockCategory: CustomDebugStringConvertible
{
    public let components: [(type: Block, probability: Double)]
    
    // public requires explicit public initialiser declaration
    public init(components: [(type: Block, probability: Double)])
    {
        self.components = components
    }
    
    // make more friendly sidebar output
    public var debugDescription : String
    {
        return "A Category of \(components.count) Blocks"
    }
}

/**
 Block type defines a component of the world: how it will look--either a texture or a flat-colored square--where in the z-axis it is drawn and whether or not it will be opaque.
 */
public struct Block: Equatable, CustomDebugStringConvertible
{
    let color: UIColor
    let texture: UIImage?
    let collision: CollisionType
    let opacity: Opacity
    
    // more friendly sidebar output
    public var debugDescription : String
    {
        if color == .clear
        {
            if texture != nil
            {
                return "A textured Block"
            }
            
            return "An invisible Block"
        }
        
        return "A colored Block"
    }
    
    
    // provide default values for easier reading in user-visible declarations
    public init(color: UIColor = .clear, texture: UIImage? = nil, collision: CollisionType = .none, opacity: Opacity = .opaque)
    {
        self.color = color
        self.texture = texture
        self.collision = collision
        self.opacity = opacity
    }
    
    // at the point of my writing this Xcode and Swift are updated to not need this, but Playgrounds on iPad is not. Totally awesome this will be inferred in the future, though :D
    public static func ==(lhs: Block, rhs: Block) -> Bool
    {
        return lhs.color == rhs.color && lhs.texture == rhs.texture && lhs.collision == rhs.collision && lhs.opacity == rhs.opacity
    }
}
