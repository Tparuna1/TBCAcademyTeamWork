//
//  PopulationPageVC.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import UIKit

class PopulationPageVC: UIViewController {
    let populationViewModel = PopulationPageViewModel()
    let populationTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    private func setupViewModel() {
        populationViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.populationTableView.reloadData()
            }
        }
        populationViewModel.viewDidLoad()
    }
    
    private func setupUI() {
        setupPopulationTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Georgia 🇬🇪"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        navigationItem.titleView = titleLabel
    }
    
    private func setupPopulationTableView() {
        populationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PopulationCell")
        populationTableView.dataSource = self
        populationTableView.translatesAutoresizingMaskIntoConstraints = false
        populationTableView.backgroundColor = .systemCyan
        
        view.addSubview(populationTableView)
        
        NSLayoutConstraint.activate([
            populationTableView.topAnchor.constraint(equalTo: view.topAnchor),
            populationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            populationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            populationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PopulationPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populationViewModel.populationData?.totalPopulation.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopulationCell", for: indexPath)
        
        if let data = populationViewModel.populationData?.totalPopulation[indexPath.row] {
            cell.textLabel?.text = "Date: \(data.date), Population: \(data.population)"
        } else {
            cell.textLabel?.text = "No Data Available"
        }
        
        cell.contentView.backgroundColor = UIColor.systemCyan
        return cell
    }
}
