public class World
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
}
