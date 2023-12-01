//
//  PopulationPageModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation


//MARK: - Models
struct PopulationData: Decodable {
    
    let totalPopulation: [PopulationInfo]
}

struct PopulationInfo: Decodable {
    let date: String
    let population: Int
}
