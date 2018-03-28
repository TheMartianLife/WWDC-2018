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
    var patternArray: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((maxStep + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        patternArray.append((x, probability))
    }
    
    return patternArray
}

public func getGroundLevelOptions(given prev: Int, _ baseline: Int, _ variance: Int, _ max_step: Int) -> [(Int, Double)]
{
    var patternArray: [(Int, Double)] = []
    
    for x in (baseline - variance)...(baseline + variance)
    {
        let difference = abs(x - prev)
        let weighting = max(((max_step + 1) - difference), 0)
        let probability = Double(weighting) / 10
        
        patternArray.append((x, probability))
    }
    
    return patternArray
}

public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T
{
    let totalProbability = options.reduce(0, { $0 +  $1.probability })
    let randomSelector = drand48() * totalProbability//Double(arc4random_uniform(UInt32(totalProbability))) / 100.0
    var cumulativeProbability = 0.0
    
    for item in options
    {
        cumulativeProbability += item.probability
        
        if randomSelector < cumulativeProbability
        {
            return item.value
        }
    }
    
    let highestProbability = options.max(by: { $0.probability < $1.probability })
    return highestProbability!.value
}
