//
//  ViewController.swift
//  Clima-Marathon
//
//  Created by User on 17.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var apiCaller = APICaller()

    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Clima"
        label.font = UIFont.systemFont(ofSize: 46, weight: .bold)
        label.textAlignment = .left
        label.textColor = .systemGray6
        
        return label
    }()
    
    lazy var inputField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter city name"
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        
        return textField
    }()
    
    lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = .systemGray6
        
        return imageView
    }()
    
    lazy var temputareStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    lazy var celciusLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.font = UIFont.systemFont(ofSize: 56)
        label.textColor = .systemGray6
        
        return label
    }()
    
    lazy var temputareLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "22"
        label.font = UIFont.systemFont(ofSize: 56, weight: .bold)
        label.textColor = .systemGray6
        
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moscow"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .right
        label.textColor = .systemGray6
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        inputField.delegate = self
        apiCaller.delegate = self
    }
}

extension ViewController {
    
    func setupView() {
        
        view.addSubview(backgroundImage)
        view.addSubview(inputField)
        view.addSubview(titleLabel)
        view.addSubview(weatherImage)
        
        temputareStack.addArrangedSubview(temputareLabel)
        temputareStack.addArrangedSubview(celciusLabel)
        
        view.addSubview(temputareStack)
        view.addSubview(cityLabel)
    }
    
    func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            safeArea.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            inputField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            inputField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            safeArea.trailingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 20),
            safeArea.trailingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 30),
            weatherImage.heightAnchor.constraint(equalToConstant: 125),
            weatherImage.widthAnchor.constraint(equalToConstant: 125)
        ])
        
        NSLayoutConstraint.activate([
            temputareStack.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
            safeArea.trailingAnchor.constraint(equalTo: temputareStack.trailingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: temputareStack.bottomAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            safeArea.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 30)
        ])
    }
}

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ apiCaller: APICaller, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temputareLabel.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


// MARK: - Text Field Delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        apiCaller.fetchWeather(city: textField.text!)
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
