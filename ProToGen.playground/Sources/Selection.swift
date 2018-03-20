import Foundation

public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T?
{
    let total_probability = options.reduce(0, { $0 + $1.probability }) * 100
    let random_selector = Double(arc4random_uniform(UInt32(total_probability))) / 100.0
    var cumulative_probability = 0.0
    var option = 0
    
    for item in options
    {
        cumulative_probability += item.probability
        
        option += 1
        if random_selector <= cumulative_probability
        {
            return item.value
        }
    }
    
    return nil
}
