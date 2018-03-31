import Foundation

// works out options to choose from, based on given values and the height of the ground to the left of it
public func getGroundLevelOptions(given prev: Int, _ baseline: Int = baseline, _ variance: Int = variance, _ maxStep: Int = maxStep) -> [(Int, Double)]
{
    var patternArray: [(Int, Double)] = []
    
    // e.g. from 2 blocks below the current level to 2 blocks above
    for x in (baseline - variance)...(baseline + variance)
    {
        // get difference, in these cases [2, 1, 0, 1, 2]
        let difference = abs(x - prev)
        // get weighting as constained by how much it is allowed to be different from the block beside it, in these cases [0, 1, 2, 1, 0]
        let weighting = max(((maxStep + 1) - difference), 0)
        // use that to define the probability of each level being chosen, now [0, 0.1, 0.2, 0.1, 0]
        let probability = Double(weighting) / 10
        // each added to the array to pick from as they are calculated
        patternArray.append((x, probability))
    }
    
    return patternArray
}

// the main driver behind all random decision-making in the whole playground: a simple weighted probability selector that runs on a random number generation
public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T
{
    // for all the values in the array given, add up the total of their probabilities (most often 1.0)
    let totalProbability = options.reduce(0, { $0 +  $1.probability })
    // get a random number between 0 and the total you just got
    let randomSelector = drand48() * totalProbability
    // start a running total to add to
    var cumulativeProbability = 0.0
    
    // go through the array of values you were gicen
    for item in options
    {
        // add the current item's probability to the running total
        cumulativeProbability += item.probability
        
        // if the random number now falls in the most recent item's range, it is the chosen one!
        if randomSelector < cumulativeProbability
        {
            return item.value
        }
    }

    // accounting for weird errors in floating point maths, a final return statement to appease the compiler
    let highestProbability = options.max(by: { $0.probability < $1.probability })
    return highestProbability!.value
    // this function does not handle being handed an empty array, but nothing that made the arrays in this playground can make one, so it was unnecessary
}
