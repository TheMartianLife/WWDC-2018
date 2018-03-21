open class World
{
    public let width: Int
    public let height: Int
    var blocks: [Block?]
    
    public init(_ width: Int, _ height: Int)
    {
        self.width = width
        self.height = height
        self.blocks = [Block?](repeating: Block(), count: width * height)
    }
    
    public subscript (_ x: Int, _ y: Int) -> Block?
    {
        get {
            return blocks[(x * height) + y]
        }
        set {
            blocks[(x * height) + y] = newValue
        }
    }
    
    public func blockBeside(_ x: Int, _ y: Int) -> Block?
    {
        if x > 0
        {
            return blocks[((x - 1) * height) + y]
        }
        
        return nil
    }
    
    public func blockBelow(_ x: Int, _ y: Int) -> Block?
    {
        if y > 0
        {
            return blocks[(x * height) + (y - 1)]
        }
        
        return nil
    }
    
    open func generate()
    {
        for x in 0..<self.width
        {
            for y in 0..<self.height
            {
                blocks[(x * height) + y] = chooseBlock(x, y)
            }
        }
    }
    
    open func chooseBlock(_ x: Int, _ y: Int) -> Block? {
        return nil
    }
}
