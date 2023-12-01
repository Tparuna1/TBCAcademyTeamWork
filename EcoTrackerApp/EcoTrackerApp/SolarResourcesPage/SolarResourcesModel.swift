//
//  SolarResourcesModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation

// MARK: - SolarResponse
struct SolarResponse: Decodable {
    struct Output: Decodable {
        struct Avg: Decodable {
            let annual: Double
        }
        let avgDni: Avg
        let avgGhi: Avg
        let avgLatTilt: Avg
    }
    let outputs: Output
}


