import UIKit

public enum CollisionType
{
    case solid
    case background
    case foreground
}

public enum Opacity
{
    case opaque
    case transparent
}

public class Block
{
    let color: UIColor
    let texture: UIImage?
    let collision: CollisionType
    let opacity: Opacity
    
    init(color: UIColor, texture: UIImage?, collision: CollisionType, opacity: Opacity)
    {
        self.color = color
        self.texture = texture
        self.collision = collision
        self.opacity = opacity
    }
    
    public convenience init(color: UIColor, texture: UIImage?, collision: CollisionType)
    {
        self.init(color: color, texture: texture, collision: collision, opacity: .opaque)
    }
    
    public convenience init(color: UIColor, collision: CollisionType)
    {
        self.init(color: color, texture: nil, collision: collision, opacity: .opaque)
    }
    
    public convenience init(color: UIColor, collision: CollisionType, opacity: Opacity)
    {
        self.init(color: color, texture: nil, collision: collision, opacity: opacity)
    }
    
    public convenience init(texture: UIImage?, collision: CollisionType )
    {
        self.init(color: .white, texture: texture, collision: collision, opacity: .opaque)
    }
    
    public convenience init(texture: UIImage?, collision: CollisionType, opacity: Opacity)
    {
        self.init(color: .white, texture: texture, collision: collision, opacity: opacity)
    }
    
    public convenience init?() {
        return nil
    }
}
