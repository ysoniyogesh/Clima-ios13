

import Foundation
struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [weather]
    var wind: Wind
}
//weather[0].description

struct Main: Decodable {
    var temp: Double
    var humidity: Double
}

struct weather: Decodable {
    var description: String
    var id: Int
}

struct Wind: Decodable {
    var speed: Double
}
