//
//  AirQualityVC.swift
//  EcoTrackerApp


import UIKit

final class AirQualityVC: UIViewController {
    // MARK: - Properties
    private var viewModel = AirQualityViewModel()
    
    private var latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Latitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private  var longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Longitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var fetchDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch Data", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(fetchDataButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var airQualityLabel: UILabel = {
        let airQualityLabel = UILabel()
        airQualityLabel.font = UIFont(name: "Helvetica-Bold", size: 25)
        airQualityLabel.textAlignment = .center
        airQualityLabel.textColor = .white
        airQualityLabel.translatesAutoresizingMaskIntoConstraints = false
        return airQualityLabel
    }()
   
    private var generalAirIndexInfo: UILabel = {
        let generalAirIndexInfo = UILabel()
        generalAirIndexInfo.text = "The AQI is an index for reporting daily air quality. It tells you how clean or unhealthy your air is"
        generalAirIndexInfo.font = UIFont(name: "Helvetica-Bold", size: 20)
        generalAirIndexInfo.textAlignment = .center
        generalAirIndexInfo.lineBreakMode = .byWordWrapping
        generalAirIndexInfo.numberOfLines = 3
        generalAirIndexInfo.textColor = .white
        generalAirIndexInfo.translatesAutoresizingMaskIntoConstraints = false
        return generalAirIndexInfo
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        viewModel.delegate = self
        
        setupUI()

    }
    
    
    // MARK: Private Methods
    private func setupUI() {
        
        
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(fetchDataButton)
        view.addSubview(airQualityLabel)
        view.addSubview(generalAirIndexInfo)
        
        NSLayoutConstraint.activate([
            latitudeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            longitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fetchDataButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            airQualityLabel.topAnchor.constraint(equalTo: fetchDataButton.bottomAnchor, constant: 20),
            airQualityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            airQualityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            generalAirIndexInfo.topAnchor.constraint(equalTo: airQualityLabel.bottomAnchor, constant: 20),
            generalAirIndexInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalAirIndexInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

    }
    
    @objc func fetchDataButtonTapped() {
        guard let lattitudeInto = latitudeTextField.text, let longtitudeInfo = longitudeTextField.text else { return }
        viewModel.fetchAirQuality(latitudeText: lattitudeInto, longtitudeText: longtitudeInfo)
    }
    
}




extension AirQualityVC: AirQualityViewModelDelegate {
    func airQualityFetched(aqi: Int) {
        DispatchQueue.main.async {
            self.airQualityLabel.text = "Air quality Index is: \(aqi)"
        }
    }
    

    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            print("error")
        }
    }
    
    
}

