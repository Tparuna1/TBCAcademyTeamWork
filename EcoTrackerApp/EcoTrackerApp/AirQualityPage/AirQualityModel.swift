//
//  AirQualityModel.swift
//  EcoTrackerApp

import Foundation


struct AirQualityModel: Decodable {
    let status: String
    let data: DataClass
}

struct DataClass: Decodable {
    let city, state, country: String
    let location: Location
    let current: Current
}

struct Current: Decodable {
    let pollution: Pollution
}

struct Pollution: Decodable {
    let ts: String
    let aqius: Int
}

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}
