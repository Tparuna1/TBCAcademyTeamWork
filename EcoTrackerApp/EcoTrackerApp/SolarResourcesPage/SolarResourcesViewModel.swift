//
//  SolarResourcesViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation
//import NetworkService


protocol SolarResourcesViewModelDelegate: AnyObject {
    func didUpdateSolarInfo(avgDirectNormalIrradiance: Double, avgGlobalHorizontalIrradiance: Double, avgTiltAtLatitude: Double)
    func didFailToUpdateSolarInfo(error: Error)
}

class SolarResourcesViewModel {
    
    private var solarInfo: SolarResponse?
    weak var delegate: SolarResourcesViewModelDelegate?
    
    func viewDidLoad() {
        fetchSolarInfo(lat: "39.282497", lon: "-111.793643")
    }
    
    func fetchSolarInfo(lat: String, lon: String) {
        let api_key = "nsNg96jLGXc5yMvqqzkN36ePDpu4mXKlVsdctZmQ"
        let url =  "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=\(api_key)&lat=\(lat)&lon=\(lon)"
        
        NetworkManager.fetchData(from: url, modelType: SolarResponse.self) { result in
            switch result {
            case .success(let solarResponse):
                self.solarInfo = solarResponse
                self.delegate?.didUpdateSolarInfo(
                    avgDirectNormalIrradiance: self.solarInfo?.outputs.avg_dni.annual ?? 0,
                    avgGlobalHorizontalIrradiance: self.solarInfo?.outputs.avg_ghi.annual ?? 0,
                    avgTiltAtLatitude: self.solarInfo?.outputs.avg_ghi.annual ?? 0
                )
                print("success")
            case .failure(let error):
                print("Error: \(error)")
                self.delegate?.didFailToUpdateSolarInfo(error: error)
            }
        }
    }
}



/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */


public final class NetworkManager {
    
    public static func fetchData<T: Decodable>(from apiURL: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data!)
                completion(.success(result))
            } catch {
                if let decodingError = error as? DecodingError {
                    print("Decoding Error: \(decodingError)")
                }
                completion(.failure(NetworkError.invalidData))
            }
        }.resume()
    }
    
}


public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}




