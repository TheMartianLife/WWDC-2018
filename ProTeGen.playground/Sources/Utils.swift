import UIKit

public enum Page
{
    case page1
    case page2
    case page3
    case page4
    case page5
}

public func getGroundLevelOptions(given prev: Int) -> [(Int, Double)]
{
    var pattern_array: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((max_step + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        pattern_array.append((x, probability))
    }
    
    return pattern_array
}

public func getGroundLevelOptions(given prev: Int, _ baseline: Int, _ variance: Int, _ max_step: Int) -> [(Int, Double)]
{
    var pattern_array: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((max_step + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        pattern_array.append((x, probability))
    }
    
    return pattern_array
}

public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T!
{
    let total_probability = options.reduce(0, { $0 +  $1.probability }) * 100
    let random_selector = Double(arc4random_uniform(UInt32(total_probability))) / 100.0
    var cumulative_probability = 0.0
    
    for item in options
    {
        cumulative_probability += item.probability
        
        if random_selector < cumulative_probability
        {
            return item.value
        }
    }
    
    if let highest_probability = options.max(by: { $0.probability < $1.probability })
    {
        return highest_probability.value
    }
    
    return nil
}
