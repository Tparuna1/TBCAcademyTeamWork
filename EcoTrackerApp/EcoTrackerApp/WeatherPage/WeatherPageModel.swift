//
//  WeatherPageModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

//
//  WeatherPageModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation

// MARK: - Weather
struct WeatherPageModel: Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let main: MainClass
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double

    enum CodingKeys: String, CodingKey {
        case temp
    }
}


// MARK: - Weather
struct Weather: Codable {
    let id: Int
}



