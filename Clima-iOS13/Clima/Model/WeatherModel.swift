

import Foundation
struct WeatherModel {
    var city: String
    var temp: Double
    var conditionID: Int
    var temperatureString: String {
        String(format: "%.01f", temp)  //temp ko string me change and one decimal tk roundoff krne k liye
    }
    
    var condition: String {     // This is a computed property
                switch conditionID {
                case 200...232 :
                    return "cloud.bolt.rain.fill"
                case 300...321 :
                    return "cloud.drizzle"
                case 500...531 :
                    return "cloud.rain"
                case 600...622 :
                    return "cloud.snow"
                case 700...781 :
                    return "cloud.fog"
                case 800 :
                    return "sun.max"
                case 801...804 :
                    return "cloud.sun"
                
                default:
                    return "cloud.sun"
                }
            }
}
