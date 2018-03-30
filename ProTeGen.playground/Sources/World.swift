public protocol Generatable
{
    func clear()
    func generate()
    subscript (_ x: Int, _ y: Int) -> Block { get set }
}

open class World: CustomDebugStringConvertible
{
    public let width: Int
    public let height: Int
    var blocks: [Block]
    
    public init(_ width: Int, _ height: Int)
    {
        self.width = width
        self.height = height
        self.blocks = [Block](repeating: air, count: width * height)
    }
    
    public subscript (_ x: Int, _ y: Int) -> Block
    {
        get {
            return valid(x, y) ? blocks[(x * height) + y] : Block()
        }
        
        set {
            if valid(x, y)
            {
                blocks[(x * height) + y] = newValue
            }
        }
    }
    
    public func clear()
    {
        self.blocks = [Block](repeating: air, count: width * height)
    }
    
    public func valid(_ x: Int, _ y: Int) -> Bool
    {
        return x >= 0 && y >= 0 && x < width && y < height
    }
    
    public func unoccupied(_ x: Int, _ y: Int) -> Bool
    {
        if valid(x, y)
        {
            let collisionType = self[x, y].collision
            return collisionType == .none || collisionType == .varied
        }
        
        return false
    }
    
    public func blockBeside(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x - 1, y) ? self[(x - 1), y] : nil
    }
    
    public func blockAbove(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x, y + 1) ? self[x, (y + 1)] : nil
    }
    
    public func blockBelow(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x, y - 1) ? self[x, (y - 1)] : nil
    }
    
    public func surfaceBeside(_ x: Int, _ y: Int) -> Block?
    {
        for y in (0..<height).reversed()
        {
            let block = valid(x - 1, y) ? self[(x - 1), y] : nil
            
            if  block != nil && block!.collision == .solid
            {
                return block
            }
        }
        
        return nil
    }
    
    public var debugDescription : String
    {
        return "World"
    }
}
