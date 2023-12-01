//
//  WeatherPageModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//


import Foundation


struct WeatherPageModel: Codable {
    let list: [List]
}


struct List: Codable {
    let main: MainClass
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}


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



