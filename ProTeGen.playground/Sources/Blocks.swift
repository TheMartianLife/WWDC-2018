import UIKit

public enum CollisionType
{
    case solid
    case background
    case foreground
    case varied
}

public enum Opacity
{
    case opaque
    case transparent
}

public struct Block: Equatable, CustomDebugStringConvertible
{
    let color: UIColor
    let texture: UIImage?
    public let collision: CollisionType
    let opacity: Opacity
    
    init(color: UIColor, texture: UIImage?, collision: CollisionType, opacity: Opacity)
    {
        self.color = color
        self.texture = texture
        self.collision = collision
        self.opacity = opacity
    }
    
    public init(color: UIColor, texture: UIImage?, collision: CollisionType)
    {
        self.init(color: color, texture: texture, collision: collision, opacity: .opaque)
    }
    
    public init(color: UIColor, collision: CollisionType)
    {
        self.init(color: color, texture: nil, collision: collision, opacity: .opaque)
    }
    
    public init(color: UIColor, collision: CollisionType, opacity: Opacity)
    {
        self.init(color: color, texture: nil, collision: collision, opacity: opacity)
    }
    
    public init(texture: UIImage?, collision: CollisionType )
    {
        self.init(color: .white, texture: texture, collision: collision, opacity: .opaque)
    }
    
    public init(texture: UIImage?, collision: CollisionType, opacity: Opacity)
    {
        self.init(color: .white, texture: texture, collision: collision, opacity: opacity)
    }
    
    public init?() {
        return nil
    }
    
    public static func ==(lhs: Block, rhs: Block) -> Bool
    {
        if lhs.color == rhs.color && lhs.texture == rhs.texture && lhs.collision == rhs.collision && lhs.opacity == rhs.opacity
        {
            return true
        }
        
        return false
    }
    
    public var debugDescription : String {
        return "A Block"
    }
}

public struct BlockCategory: CustomDebugStringConvertible
{
    public let components: [(type: Block, probability: Double)]
    
    public init(components: [(type: Block, probability: Double)])
    {
        self.components = components
    }
    
    public var debugDescription : String {
        return "A Category of Blocks"
    }
}

public struct Biome
{
    let temperature: Temperature
    let humidity: Humidity
    
    init(temperature: Temperature, humidity: Humidity)
    {
        self.temperature = temperature
        self.humidity = humidity
    }
}

public enum Temperature
{
    case cold
    case moderate
    case hot
}

public enum Humidity
{
    case wet
    case moderate
    case dry
}
