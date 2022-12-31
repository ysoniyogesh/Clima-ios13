

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
var weatherURL =  "https://api.openweathermap.org/data/2.5/weather?&appid=0638e87e5dcde3e8f4ccc1718a5fa59c&units=metric"
    
    func fetchWeather(cityName: String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
   func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Create an URL
        
        if let url = URL(string: urlString) {
            
            // 2. Create a URL session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                   
                }
                if let safedata = data {
                    if let weather = self.parseJSON(safedata) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
            
        }
        

    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do
        {
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            let weatherModel = WeatherModel(city: city, temp: temp, conditionID: id)
            print(weatherModel.condition)
            print(weatherModel.temp)
            print(weatherModel.temperatureString)
            
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
