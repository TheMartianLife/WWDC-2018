/**
 Protocols! Avoid those nasty override keywords all through the user-visible parts of the playground by defining a protocol that all World extensions then adhere to. This releases us from the obligation to define a default implementation of the things the Scene calls to make controls, or making differently-named subclasses everywhere.
 */
public protocol Generatable
{
    func clear() // it will be able to clear its blocks array without making a new World
    func generate() // it will be able to populate its blocks array in some way
    subscript (_ x: Int, _ y: Int) -> Block { get set }
}

/**
 World type provides a nice wrapper around a vector (one-dimensional array), so that it can be treated like a two-dimensional array/grid of values. This is more friendly to mapping the way it works to how the user sees it in the scene.
 */
open class World: CustomDebugStringConvertible
{
    let width: Int // how many blocks wide
    let height: Int // how many blocks high
    var blocks: [Block] // the blocks themselves
        
    // more friendly sidebar output
    public var debugDescription : String
    {
        return "A \(width) x \(height) World"
    }
    
    
    // initialiser makes world of air to start with
    public init(_ width: Int, _ height: Int)
    {
        self.width = width
        self.height = height
        self.blocks = [Block](repeating: air, count: width * height)
    }
    
    // get those lovely array-like subscripts, but protect against invalid values
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
    
    // revert to all-air world
    public func clear()
    {
        self.blocks = [Block](repeating: air, count: width * height)
    }
    
    // check if the block is within the bounds of the world before you try to do anything with it
    public func valid(_ x: Int, _ y: Int) -> Bool
    {
        return x >= 0 && y >= 0 && x < width && y < height
    }
    
    // checks if something is air or a block with lower priority that should be overwritten during generate(). An example of this is that tree leaves write over long grass they collide with that was placed before the tree was.
    public func unoccupied(_ x: Int, _ y: Int) -> Bool
    {
        if valid(x, y)
        {
            let collisionType = self[x, y].collision
            return collisionType == .none || collisionType == .varied
        }
        
        return false
    }
    
    // the block to the left of x, y
    public func blockBeside(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x - 1, y) ? self[(x - 1), y] : nil
    }
    
    // the block above x, y
    public func blockAbove(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x, y + 1) ? self[x, (y + 1)] : nil
    }
    
    // the block below x, y
    public func blockBelow(_ x: Int, _ y: Int) -> Block?
    {
        return valid(x, y - 1) ? self[x, (y - 1)] : nil
    }
    
    // the block at ground level to the left of x, y
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
}
