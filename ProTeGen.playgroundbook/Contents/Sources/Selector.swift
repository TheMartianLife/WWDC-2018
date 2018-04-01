import Foundation

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
