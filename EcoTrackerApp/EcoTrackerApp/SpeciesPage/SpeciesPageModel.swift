//
//  SpeciesPageModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation

struct SpeciesDefaultPhoto: Decodable {
    let attribution: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case attribution = "attribution"
        case url = "url"
    }
}

struct SpeciesTaxon: Decodable {
    let name: String
    let defaultPhoto: SpeciesDefaultPhoto?
    let attribution: String?
    let wikipediaURL: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case defaultPhoto = "default_photo"
        case attribution = "attribution"
        case wikipediaURL = "wikipedia_url"
    }
}

struct SpeciesPageModel: Decodable {
    let speciesName: String
    let speciesWikipediaLink: String?
    let speciesImageUrl: String?
    let speciesDefaultPhoto: SpeciesDefaultPhoto?

    enum CodingKeys: String, CodingKey {
        case speciesName
        case speciesWikipediaLink
        case speciesImageUrl
        case speciesDefaultPhoto = "defaultPhoto"
    }
}

struct AutocompleteResponse: Decodable {
    let totalResults: Int
    let results: [AutocompleteResult]

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case results
    }
}

struct AutocompleteResult: Decodable {
    let id: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

struct SpeciesCountResult: Decodable {
    let count: Int
    let taxon: SpeciesTaxon

    enum CodingKeys: String, CodingKey {
        case count
        case taxon
    }
}

struct SpeciesCountResponse: Decodable {
    let totalResults: Int
    let results: [SpeciesCountResult]

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case results
    }
}


