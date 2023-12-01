//
//  WeatherPageViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//


//
//  WeatherPageViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation
import NetworkService
protocol WeatherPageViewModelDelegate: AnyObject{
    func didUpdateWeather(temp: Double)
}

final class WeatherPageViewModel {
    
    private var weatherInfo: WeatherPageModel?
    var weatherModel: WeatherPageModel?
    weak var delegate: WeatherPageViewModelDelegate?
    
    
    
  
    func fetchWeatherInfo(latitude: String, longitude: String) {
        let apiKey = "55455786ec6fc137859ad01e798c2284"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        NetworkService.fetchData(from: urlString) { [weak self] (result: Result<WeatherPageModel, Error>) in
            switch result {
            case .success(let weatherResponse):
                self?.weatherInfo = weatherResponse
                if let firstList = self?.weatherInfo?.list.first {
                    self?.delegate?.didUpdateWeather(temp: firstList.main.temp)
                }
                print("Success")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }


}
