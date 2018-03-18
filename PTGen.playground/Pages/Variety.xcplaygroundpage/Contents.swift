//: # Procedural Terrain Generation
//: What we've done...
//: ## And finally, some variety
//#-hidden-code

//#-end-hidden-code
struct Feature
{

}

struct Biome
{
    let temperature: Temperature
    let humidity: Humidity
    let features: [Feature]
}

enum Temperature
{
    case cold
    case moderate
    case hot
}

enum Humidity
{
    case wet
    case moderate
    case dry
}
//:
let normal = Biome(temperature: .moderate, humidity: .moderate, features: [])
let desert = Biome(temperature: .hot, humidity: .dry, features: [])
let jungle = Biome(temperature: .hot, humidity: .wet, features: [])
let snowy = Biome(temperature: .cold, humidity: .moderate, features: [])
//:
func chooseBlock(x: Int, y: Int, biome: Biome)
{
    // if biome == desert
}
//: [< Features](Features) | [Extras >](Beyond)

