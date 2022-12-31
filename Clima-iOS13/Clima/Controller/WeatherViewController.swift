

import UIKit
import CoreLocation  // To get current location data of user this library is used.

class WeatherViewController: UIViewController  {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


//MARK: WeatherViewController: UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    // this function enables textfield to perform return when "Go" button is pressed on keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // to make the keyboard disappear
        //print(searchTextField.text!)
        return true
    }
   
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    // this function inform viewconroller that use has end editing. so in this function we instruct to clear searchTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
           weatherManager.fetchWeather(cityName: city)
            
        }
        searchTextField.text = ""
    }
}
//MARK:  SWeatherViewController: WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.condition)
            self.cityLabel.text = weather.city
        }
       
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got the locations")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
         }
            
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

