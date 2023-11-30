//
//  SolarResourcesModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation

//// MARK: - SolarResponse
//struct SolarResponse: Decodable {
//    let outputs: Outputs
//}
//
//// MARK: - Outputs
//struct Outputs: Decodable {
//    let avg_dni: Avg
//    let avg_ghi: Avg
//    let avg_lat_tilt: Avg
//}
//
//// MARK: - Avg
//struct Avg: Decodable {
//    let annual: Double
//    let monthly: [String: Double]
//}

struct SolarResponse: Decodable {
    
    struct Output: Decodable {
        
        struct Avg: Decodable {
            let annual: Double
        }
        
        let avg_dni: Avg
        let avg_ghi: Avg
        let avg_lat_tilt: Avg
    }
    
    let outputs: Output

}


