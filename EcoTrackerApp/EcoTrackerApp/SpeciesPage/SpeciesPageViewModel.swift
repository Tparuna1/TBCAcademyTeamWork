//
//  SpeciesPageViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//


import Foundation


final class SpeciesPageViewModel {

    private var speciesData: [SpeciesPageModel] = []

    enum APIError: Error {
        case invalidURL
        case networkError(Error)
        case noData
        case decodingError(Error)
        case cityIDNotFound
    }

    func numberOfSpecies() -> Int {
        speciesData.count
    }

    func species(at index: Int) -> SpeciesPageModel? {
        guard index < speciesData.count else {
            return nil
        }
        return speciesData[index]
    }

    func updateSpeciesData(with data: [SpeciesCountResult]) {
        let newSpeciesData = data.map { speciesCountResult in
            let defaultPhoto = speciesCountResult.taxon.defaultPhoto
            return SpeciesPageModel(
                speciesName: speciesCountResult.taxon.name,
                speciesWikipediaLink: speciesCountResult.taxon.wikipediaURL,
                speciesImageUrl: defaultPhoto?.url ?? "",
                speciesDefaultPhoto: defaultPhoto
            )
        }
        self.speciesData = newSpeciesData
    }

    func fetchData(for cityName: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        fetchAutocompleteData(for: cityName) { [weak self] result in
            switch result {
            case .success(let autocompleteData):
                print("Autocomplete Response: \(autocompleteData)")
                guard let cityID = autocompleteData.results.first?.id else {
                    print("City ID not found in autocomplete results")
                    completion(.failure(.cityIDNotFound))
                    return
                }

                let baseURL = "https://api.inaturalist.org/v1/observations/species_counts?place_id="
                self?.fetchSpeciesCountData(withBaseURL: baseURL, cityID: cityID) { result in
                    switch result {
                    case .success(let fetchedData):
                        print("Species Count Response: \(fetchedData)")

                        let newSpeciesData = fetchedData.results.map { speciesCountResult in
                            let defaultPhoto = speciesCountResult.taxon.defaultPhoto
                            return SpeciesPageModel(
                                speciesName: speciesCountResult.taxon.name,
                                speciesWikipediaLink: speciesCountResult.taxon.wikipediaURL,
                                speciesImageUrl: defaultPhoto?.url ?? "",
                                speciesDefaultPhoto: defaultPhoto
                            )
                        }

                        self?.speciesData = newSpeciesData
                        completion(.success(()))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchAutocompleteData(for cityName: String, completion: @escaping (Result<AutocompleteResponse, APIError>) -> Void) {
        let autocompleteURL = "https://api.inaturalist.org/v1/places/autocomplete?q=\(cityName)"
        print("Fetching autocomplete data for city: \(cityName)")

        guard let url = URL(string: autocompleteURL) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let autocompleteData = try decoder.decode(AutocompleteResponse.self, from: data)
                completion(.success(autocompleteData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }

    private func fetchSpeciesCountData(withBaseURL baseURL: String, cityID: Int, completion: @escaping (Result<SpeciesCountResponse, APIError>) -> Void) {
        let speciesDataURL = "\(baseURL)\(cityID)"

        guard let url = URL(string: speciesDataURL) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let speciesCountData = try decoder.decode(SpeciesCountResponse.self, from: data)
                completion(.success(speciesCountData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }

    func clearSpeciesData() {
        speciesData = []
    }
}


