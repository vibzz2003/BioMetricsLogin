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

final class SignInViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signInButton = UIButton(type: .system)
    private let biometricButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBiometricButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Title
        titleLabel.text = "Welcome Back"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure text fields
        configureTextField(emailTextField, placeholder: "Email", keyboardType: .emailAddress)
        configureTextField(passwordTextField, placeholder: "Password", isSecure: true)
        
        // Sign in button
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = .systemBlue
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = 25
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        // Biometric button
        biometricButton.backgroundColor = .systemGreen
        biometricButton.setTitleColor(.white, for: .normal)
        biometricButton.layer.cornerRadius = 25
        biometricButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        biometricButton.translatesAutoresizingMaskIntoConstraints = false
        biometricButton.addTarget(self, action: #selector(biometricSignInTapped), for: .touchUpInside)
        
        // Sign up button
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // Loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(biometricButton)
        view.addSubview(signUpButton)
        view.addSubview(loadingIndicator)
        
        setupConstraints()
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func setupBiometricButton() {
        let biometricType = BiometricClass.shared.GetBiometricType()
        
        if biometricType != .None && AuthManager.shared.GetUserProfile()?.hasBiometricsEnabled == true {
            biometricButton.setTitle("Sign in with \(biometricType.displayName)", for: .normal)
            biometricButton.isHidden = false
        } else {
            biometricButton.isHidden = true
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            biometricButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 16),
            biometricButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            biometricButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            biometricButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: biometricButton.bottomAnchor, constant: 24),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor)
        ])
    }
    
    @objc private func signInTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter email and password")
            return
        }
        
        loadingIndicator.startAnimating()
        signInButton.setTitle("", for: .normal)
        
        AuthManager.shared.SignIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.signInButton.setTitle("Sign In", for: .normal)
                
                switch result {
                case .success:
                    self?.navigateToHome()
                case .failure(let error):
                    self?.showAlert(title: "Sign In Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func biometricSignInTapped() {
        AuthManager.shared.SignInWithBiometrics { [weak self] result in
            switch result {
            case .success:
                self?.navigateToHome()
            case .failure(let error):
                self?.showAlert(title: "Biometric Sign In Failed", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpTapped() {
        dismiss(animated: true)
    }
    
    private func navigateToHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
