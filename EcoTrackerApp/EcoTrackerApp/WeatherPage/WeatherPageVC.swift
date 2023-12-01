//
//  WeatherPageVC.swift
//  EcoTrackerApp
//
//  Created by tornike <parunashvili on 29.11.23.
//

import UIKit

final private class WeatherPageVC: UIViewController {
    
    var viewModel = WeatherPageViewModel()
    
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Latitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Longitude"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let showWeatherButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Weather", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature: 0 °C"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.systemCyan
        viewModel.delegate = self
        
        setupLatitudeTextField()
        setupLongitudeTextField()
        setupShowWeatherButton()
        setupWeatherLabel()
        
        setupTemperatureTextField()
        
        
    }
    
    private func setupLatitudeTextField() {
        view.addSubview(latitudeTextField)
        
        NSLayoutConstraint.activate([
            latitudeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupLongitudeTextField() {
        view.addSubview(longitudeTextField)
        
        NSLayoutConstraint.activate([
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 10),
            longitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupShowWeatherButton() {
        view.addSubview(showWeatherButton)
        
        
        showWeatherButton.addTarget(self, action: #selector(showWeatherButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showWeatherButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 10),
            showWeatherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showWeatherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showWeatherButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupWeatherLabel() {
        view.addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: showWeatherButton.bottomAnchor, constant: 20),
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTemperatureTextField() {
        view.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather: N/A"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weatherMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Main Weather: N/A"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc func showWeatherButtonTapped() {
        guard let latitudeText = latitudeTextField.text, let longtitudeText = longitudeTextField.text else {return}
        viewModel.fetchWeatherInfo(latitude: latitudeText, longitude: longtitudeText)
    }
    
    private func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: showWeatherButton.bottomAnchor, constant: 10),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    private func setupWeatherDescriptionLabel() {
        view.addSubview(weatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupWeatherMainLabel() {
        view.addSubview(weatherMainLabel)
        
        NSLayoutConstraint.activate([
            weatherMainLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 20),
            weatherMainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherMainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension WeatherPageVC: WeatherPageViewModelDelegate {
func didUpdateWeather(temp: Double) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "Temperature: \(temp) °C"
        
        }
    }
    
}

