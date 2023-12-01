//
//  AirQualityViewModel.swift
//  EcoTrackerApp
//

import Foundation
import NetworkService

protocol AirQualityViewModelDelegate: AnyObject {
    func airQualityFetched(aqi: Int)
    func showError(_ error: Error)
}


final class AirQualityViewModel {
    private var airQualityModel: AirQualityModel?
    weak var delegate: AirQualityViewModelDelegate?

    func fetchAirQuality(latitudeText: String, longtitudeText: String) {
        let airQualityAPI = "685f8cde-7d2d-4233-923f-33caccdf2bcd"
        let airQualityUrl = "https://api.airvisual.com/v2/nearest_city?lat=\(latitudeText)&lon=\(longtitudeText)&key=\(airQualityAPI)"
        NetworkService.fetchData(from: airQualityUrl) { [weak self] (result: Result<AirQualityModel, Error>) in
            switch result {
            case .success(let airQualityResponse):
                self?.airQualityModel = airQualityResponse
                self?.delegate?.airQualityFetched(aqi: self?.airQualityModel?.data.current.pollution.aqius ?? 0)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
        
    }
    
}
