//
//  SpeciesPageVC.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import UIKit

final class SpeciesPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: -properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter a city name"
        searchBar.delegate = self
        return searchBar
    }()
    
    private var viewModel: SpeciesPageViewModel!
    
    //MARK: -lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        setupTableView()
        setupSearchBar()
        viewModel = SpeciesPageViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSpecies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpeciesPageTableViewCell.reuseIdentifier, for: indexPath) as? SpeciesPageTableViewCell else {
            fatalError("Unable to dequeue SpeciesPageTableViewCell")
        }
        
        let species = viewModel.species(at: indexPath.row)
        cell.configure(with: species)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let species = viewModel.species(at: indexPath.row),
              let wikipediaURLString = species.speciesWikipediaLink,
              let wikipediaURL = URL(string: wikipediaURLString) else {
            return
        }
        UIApplication.shared.open(wikipediaURL, options: [:], completionHandler: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text, !cityName.isEmpty else {
            print("City name is empty")
            viewModel.clearSpeciesData()
            tableView.reloadData()
            return
        }
        
        print("Fetching data for city: \(cityName)")
        
        viewModel.fetchData(for: cityName) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    print("Reload Data Called")
                }
                
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemCyan
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SpeciesPageTableViewCell.self, forCellReuseIdentifier: SpeciesPageTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.tintColor = .white
        
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.attributedPlaceholder = NSAttributedString(string: "Enter a city name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemCyan])
        
        navigationItem.titleView = searchBar
    }
}

final class SpeciesPageTableViewCell: UITableViewCell {
    //MARK: -properties
    static let reuseIdentifier = "SpeciesPageCell"
    
    private let speciesImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let attributionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let wikipediaURLLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        setupSpeciesImageView()
        setupNameLabel()
        setupAttributionLabel()
        setupWikipediaURLLabel()
        contentView.backgroundColor = .systemCyan
        backgroundColor = .systemCyan
    }
    
    private func setupSpeciesImageView() {
        speciesImageView.contentMode = .scaleAspectFit
        speciesImageView.clipsToBounds = true
        speciesImageView.backgroundColor = .systemCyan
        speciesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(speciesImageView)
        
        NSLayoutConstraint.activate([
            speciesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            speciesImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            speciesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            speciesImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.backgroundColor = .systemCyan
        
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    private func setupAttributionLabel() {
        attributionLabel.font = UIFont.systemFont(ofSize: 14)
        attributionLabel.translatesAutoresizingMaskIntoConstraints = false
        attributionLabel.numberOfLines = 0
        attributionLabel.backgroundColor = .systemCyan
        
        contentView.addSubview(attributionLabel)
        
        NSLayoutConstraint.activate([
            attributionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            attributionLabel.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 8),
            attributionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    private func setupWikipediaURLLabel() {
        wikipediaURLLabel.textColor = .blue
        wikipediaURLLabel.font = UIFont.systemFont(ofSize: 14)
        wikipediaURLLabel.translatesAutoresizingMaskIntoConstraints = false
        wikipediaURLLabel.numberOfLines = 0
        wikipediaURLLabel.isUserInteractionEnabled = true
        wikipediaURLLabel.backgroundColor = .systemCyan
        
        contentView.addSubview(wikipediaURLLabel)
        
        NSLayoutConstraint.activate([
            wikipediaURLLabel.topAnchor.constraint(equalTo: attributionLabel.bottomAnchor, constant: 4),
            wikipediaURLLabel.leadingAnchor.constraint(equalTo: speciesImageView.trailingAnchor, constant: 8),
            wikipediaURLLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with species: SpeciesPageModel?) {
        if let species = species {
            nameLabel.text = species.speciesName
            attributionLabel.text = species.speciesDefaultPhoto?.attribution ?? ""
            wikipediaURLLabel.text = species.speciesWikipediaLink ?? ""
            
            if let speciesImageUrl = species.speciesImageUrl, let url = URL(string: speciesImageUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.speciesImageView.image = image
                        }
                    }
                }
            } else {
                speciesImageView.image = UIImage(systemName: "laurel.trailing")
            }
        } else {
            nameLabel.text = ""
            attributionLabel.text = ""
            wikipediaURLLabel.text = ""
            speciesImageView.image = nil
        }
    }
}
