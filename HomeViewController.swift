//
// ///////////////////////////////////////////////////////////////////////////////////////
//
//
//  All rights reserved by OneBanc. Redistribution or use, is strictly prohibited
//
//
//  Copyright © 2025 OneBanc Technologies Private Ltd.  https://onebanc.ai/
//
//
// ///////////////////////////////////////////////////////////////////////////////////////
import UIKit

final class HomeViewController: UIViewController {
    
    private let welcomeLabel = UILabel()
    private let userInfoView = UIView()
    private let emailLabel = UILabel()
    private let usernameLabel = UILabel()
    private let biometricStatusLabel = UILabel()
    private let biometricToggle = UISwitch()
    private let biometricStackView = UIStackView()
    private let settingsButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUserInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Welcome label
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // User info view
        userInfoView.backgroundColor = .systemBackground
        userInfoView.layer.cornerRadius = 16
        userInfoView.layer.shadowColor = UIColor.black.cgColor
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userInfoView.layer.shadowRadius = 8
        userInfoView.layer.shadowOpacity = 0.1
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // Email label
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = .secondaryLabel
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Username label
        usernameLabel.font = UIFont.systemFont(ofSize: 16)
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Biometric status
        biometricStatusLabel.text = "Biometric Authentication"
        biometricStatusLabel.font = UIFont.systemFont(ofSize: 16)
        biometricStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        biometricToggle.addTarget(self, action: #selector(biometricToggleChanged), for: .valueChanged)
        biometricToggle.translatesAutoresizingMaskIntoConstraints = false
        
        biometricStackView.axis = .horizontal
        biometricStackView.spacing = 12
        biometricStackView.alignment = .center
        biometricStackView.addArrangedSubview(biometricStatusLabel)
        biometricStackView.addArrangedSubview(biometricToggle)
        biometricStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Settings button
        settingsButton.setTitle("Account Settings", for: .normal)
        settingsButton.backgroundColor = .systemBlue
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.layer.cornerRadius = 25
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        // Logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 25
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(welcomeLabel)
        view.addSubview(userInfoView)
        userInfoView.addSubview(emailLabel)
        userInfoView.addSubview(usernameLabel)
        userInfoView.addSubview(biometricStackView)
        view.addSubview(settingsButton)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            userInfoView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailLabel.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -20),
            
            biometricStackView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16),
            biometricStackView.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 20),
            biometricStackView.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -20),
            biometricStackView.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: -20),
            
            settingsButton.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 40),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateUserInfo() {
        guard let user = AuthManager.shared.GetUserProfile() else {
            navigateToSignIn()
            return
        }
        
        welcomeLabel.text = "Welcome back,\n\(user.fullName)!"
        emailLabel.text = "Email: \(user.email)"
        usernameLabel.text = "Username: @\(user.userName)"
        biometricToggle.isOn = user.hasBiometricsEnabled
        
        let biometricType = BiometricClass.shared.GetBiometricType()
        biometricStackView.isHidden = (biometricType == .None)
        
        if biometricType != .None {
            biometricStatusLabel.text = "\(biometricType.displayName) Authentication"
        }
    }
    
    @objc private func biometricToggleChanged() {
        let isEnabled = biometricToggle.isOn
        
        if isEnabled {
            // Verify biometric before enabling
            BiometricClass.shared.AuthenticateUsingBiometrics(reason: "Verify your identity to enable biometric authentication") { [weak self] success, error in
                if success {
                    self?.updateBiometricSetting(enabled: true)
                } else {
                    self?.biometricToggle.setOn(false, animated: true)
                    self?.showAlert(title: "Authentication Failed", message: "Biometric verification failed. Please try again.")
                }
            }
        } else {
            updateBiometricSetting(enabled: false)
        }
    }
    
    private func updateBiometricSetting(enabled: Bool) {
        AuthManager.shared.UpdateBiometricsSetting(biometricEnabled: enabled) { [weak self] result in
            switch result {
            case .success:
                let message = enabled ? "Biometric authentication enabled successfully" : "Biometric authentication disabled"
                self?.showAlert(title: "Success", message: message)
            case .failure(let error):
                self?.biometricToggle.setOn(!enabled, animated: true)
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func settingsTapped() {
        let alert = UIAlertController(title: "Account Settings", message: "Settings functionality can be added here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            AuthManager.shared.SignOut()
            self?.navigateToSignIn()
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToSignIn() {
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
