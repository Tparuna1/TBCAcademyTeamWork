//
//  SolarResourcesViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation
import NetworkService

protocol SolarResourcesViewModelDelegate: AnyObject {
    func didUpdateSolarInfo(avgDirectNormalIrradiance: Double, avgGlobalHorizontalIrradiance: Double, avgTiltAtLatitude: Double)
}


// MARK: SolarResourcesViewModel
final class SolarResourcesViewModel {
    
    // MARK: Properties
    private var solarInfo: SolarResponse?
    private var latitudeSuitable: Bool?
    private var irradianceSuitable: Bool?
    
    weak var delegate: SolarResourcesViewModelDelegate?
    
    // MARK: Fetching Solar Info
    func fetchSolarInfo(lat: String, lon: String) {
        let api_key = SolarConstants.API_KEY
        let baseUrl = SolarConstants.SolarBaseUrl
        let url = "\(baseUrl)api_key=\(api_key)&lat=\(lat)&lon=\(lon)"
        
        NetworkService.fetchData(from: url) { [weak self] (result: Result<SolarResponse, Error>) in
            switch result {
            case .success(let solarResponse):
                self?.solarInfo = solarResponse
                self?.delegate?.didUpdateSolarInfo(
                    avgDirectNormalIrradiance: solarResponse.outputs.avgDni.annual,
                    avgGlobalHorizontalIrradiance: solarResponse.outputs.avgGhi.annual,
                    avgTiltAtLatitude: solarResponse.outputs.avgLatTilt.annual
                )
                print("Success")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


// MARK: Constants
struct SolarConstants {
    static let SolarBaseUrl = "https://developer.nrel.gov/api/solar/solar_resource/v1.json?"
    static let API_KEY = "nsNg96jLGXc5yMvqqzkN36ePDpu4mXKlVsdctZmQ"
}
