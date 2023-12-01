//
//  SolarResourcesVC.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import UIKit

// MARK: Solar ViewController
final class SolarResourcesVC: UIViewController {
    
    // MARK: Properties
    private let latTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Latitude"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let longTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Longitude"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let solarInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Data", for: .normal)
        button.backgroundColor = UIColor(red: 252/255.0, green: 109/255.0, blue: 25/255.0, alpha: 1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let avgDniLabel: UILabel = {
        let label = UILabel()
        label.text = "Average Direct Normal Irradiance: 0.0"
        return label
    }()
    
    private let avgGhiLabel: UILabel = {
        let label = UILabel()
        label.text = "Average Global Horizontal Irradiance: 0.0"
        return label
    }()
    
    private let avgLatTiltLabel: UILabel = {
        let label = UILabel()
        label.text = "Average Tilt at Latitude: 0.0"
        return label
    }()
    
    private let solarAccess: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Latitude"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let coordsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let solarInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Solar ViewModel reference
    private let viewModel = SolarResourcesViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        viewModel.delegate = self
        setupSolarUI()
        solarInfoButton.addTarget(self, action: #selector(getSolarInfo), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setupSolarUI() {
        setupCoordsStackView()
        setupSolarStackView()
    }
    
    private func setupCoordsStackView() {
        view.addSubview(coordsStackView)
        coordsStackView.addArrangedSubview(latTextField)
        coordsStackView.addArrangedSubview(longTextField)
        coordsStackView.addArrangedSubview(solarInfoButton)
        
        NSLayoutConstraint.activate([
            coordsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            coordsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            coordsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
    
    private func setupSolarStackView() {
        view.addSubview(solarInfoStackView)
        solarInfoStackView.addArrangedSubview(avgDniLabel)
        solarInfoStackView.addArrangedSubview(avgGhiLabel)
        solarInfoStackView.addArrangedSubview(avgLatTiltLabel)
        
        NSLayoutConstraint.activate([
            solarInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            solarInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            solarInfoStackView.topAnchor.constraint(equalTo: coordsStackView.bottomAnchor, constant: 50)
        ])
    }
    
    // MARK: Button Action
    @objc private func getSolarInfo() {
        guard let latitudeText = latTextField.text, let longitudeText = longTextField.text else { return }
        viewModel.fetchSolarInfo(lat: latitudeText, lon: longitudeText)
    }

}


// MARK: - SolarResourcesViewModelDelegate
extension SolarResourcesVC: SolarResourcesViewModelDelegate {
    
    func didUpdateSolarInfo(avgDirectNormalIrradiance: Double, avgGlobalHorizontalIrradiance: Double, avgTiltAtLatitude: Double) {
        DispatchQueue.main.async {
            self.avgDniLabel.text = "Average Direct Normal Irradiance: \(avgDirectNormalIrradiance)"
            self.avgGhiLabel.text = "Average Global Horizontal Irradiance: \(avgGlobalHorizontalIrradiance)"
            self.avgLatTiltLabel.text = "Average Tilt at Latitude: \(avgTiltAtLatitude)"
        }
    }
    
}

