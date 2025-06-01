
// MARK: - Sign Up View Controller
import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let usernameTextField = UITextField()
    private let fullNameTextField = UITextField()
    private let biometricToggle = UISwitch()
    private let biometricLabel = UILabel()
    private let biometricStackView = UIStackView()
    private let signUpButton = UIButton(type: .system)
    private let signInButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBiometricOption()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.delegate = self
        fullNameTextField.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure text fields
        configureTextField(emailTextField, placeholder: "Email", keyboardType: .emailAddress)
        configureTextField(passwordTextField, placeholder: "Password", isSecure: true)
        configureTextField(confirmPasswordTextField, placeholder: "Confirm Password", isSecure: true)
        configureTextField(usernameTextField, placeholder: "Username")
        configureTextField(fullNameTextField, placeholder: "Full Name")
        
        // Biometric option
        biometricLabel.text = "Enable \(BiometricClass.shared.GetBiometricType().displayName)"
        biometricLabel.font = UIFont.systemFont(ofSize: 16)
        biometricToggle.isOn = false
        
        biometricStackView.axis = .horizontal
        biometricStackView.spacing = 12
        biometricStackView.alignment = .center
        biometricStackView.addArrangedSubview(biometricLabel)
        biometricStackView.addArrangedSubview(biometricToggle)
        biometricStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Sign up button
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 25
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // Sign in button
        signInButton.setTitle("Already have an account? Sign In", for: .normal)
        signInButton.setTitleColor(.systemBlue, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        // Loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        // Add subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(fullNameTextField)
        contentView.addSubview(biometricStackView)
        contentView.addSubview(signUpButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(loadingIndicator)
        
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
    
    private func setupBiometricOption() {
        let biometricType = BiometricClass.shared.GetBiometricType()
        biometricStackView.isHidden = (biometricType == .None)
        
        if biometricType != .None {
            biometricLabel.text = "Enable \(biometricType.displayName)"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            fullNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            fullNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            biometricStackView.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 24),
            biometricStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            biometricStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            signUpButton.topAnchor.constraint(equalTo: biometricStackView.bottomAnchor, constant: 32),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
            
            signInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func signUpTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty,
              let fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        loadingIndicator.startAnimating()
        signUpButton.setTitle("", for: .normal)
        
        AuthManager.shared.SignUp(
            email: email,
            password: password,
            username: username,
            fullName: fullName,
            enableBiometric: biometricToggle.isOn
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.signUpButton.setTitle("Create Account", for: .normal)
                
                switch result {
                case .success:
                    self?.navigateToHome()
                case .failure(let error):
                    self?.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func signInTapped() {
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
