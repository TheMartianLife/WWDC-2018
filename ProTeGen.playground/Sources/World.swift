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
            return blocks[(x * height) + y]
        }
        set {
            if valid(x, y)
            {
                blocks[(x * height) + y] = newValue
            }
        }
    }
    
    public func valid(_ x: Int, _ y: Int) -> Bool
    {
        return x >= 0 && y >= 0 && x < width && y < height
    }
    
    public func blockBeside(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x - 1, y) ? blocks[((x - 1) * height) + y] : nil
    }
    
    public func blockBelow(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x, y - 1) ? blocks[(x * height) + (y - 1)] : nil
    }
    
    public func surfaceBeside(_ x: Int, _ y: Int) -> Block?
    {
        for i in (0..<height).reversed()
        {
            let block = valid(x - 1, i) ? blocks[((x - 1) * height) + i] : nil
            
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
