/*
 <Selection.swift> by Mars Geldard

 Used for all decision-making based on weighted probabilities throughout.
 !!!WARNING!!!: Doesn't handle being passed an empty array, as it does't need to for this.
 */
import Foundation

public func chooseFrom<T>(_ options: [(value: T, probability: Double)]) -> T
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

    return options[0].value
}

