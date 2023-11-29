//
//  PopulationPageViewModel.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import Foundation
import NetworkService

class PopulationPageViewModel {
    var populationData: PopulationData?
    
    var onUpdate: (() -> Void)?
    
    func viewDidLoad() {
        fetchPopulationData()
    }
    
    func fetchPopulationData() {
        let urlString = "https://d6wn6bmjj722w.population.io:443/1.0/population/Georgia/today-and-tomorrow/"
        
        NetworkService.fetchData(from: urlString) { [weak self] (result: Result<PopulationData, Error>) in
            switch result {
            case .success(let data):
                self?.populationData = data
                self?.onUpdate?()
            case .failure(let error):
                // Handle failure
                print("Error fetching population data: \(error)")
            }
        }
    }
}
