//
//  LogInScreen.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import SwiftUI
import UIKit

struct LogInScreen: UIViewRepresentable {
    // Closure callbacks to be called when each button is tapped.

    var onForgotPassword: () -> Void = {}
    var onSignUp: () -> Void = {}
    var onSignIn: () -> Void = {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSignIn: onSignIn, onForgotPassword: onForgotPassword, onSignUp: onSignUp)
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        // Create a vertical stack view to layout components.
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Constrain the stack view to the container.
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        // Page label.
        let pageLabel = UILabel()
        pageLabel.text = "Sign In"
        pageLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        pageLabel.textAlignment = .center
        stackView.addArrangedSubview(pageLabel)
        
        // Username input.
        let usernameInput = UITextField()
        usernameInput.placeholder = "email"
        usernameInput.borderStyle = .roundedRect
        usernameInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(usernameInput)
        // Password input.
        let passwordInput = UITextField()
        passwordInput.placeholder = "Password"
        passwordInput.borderStyle = .roundedRect
        passwordInput.isSecureTextEntry = true
        passwordInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(passwordInput)
        
        context.coordinator.usernameInput = usernameInput
        context.coordinator.passwordInput = passwordInput
        
        // Sign In button.
        let signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .systemBlue
        signInButton.layer.cornerRadius = 8
        signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        signInButton.addTarget(context.coordinator, action: #selector(Coordinator.handleSignIn), for: .touchUpInside)
        stackView.addArrangedSubview(signInButton)
        
        // Create a horizontal stack view for Forgot Password & Create Account.
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(hStackView)
        
        
        let forgotPasswordButton = UIButton()
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswordButton.backgroundColor = .white
        forgotPasswordButton.addTarget(context.coordinator, action: #selector(Coordinator.handleForgotPassword), for: .touchUpInside)
        hStackView.addArrangedSubview(forgotPasswordButton)
        
        let signUpButton = UIButton()
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.addTarget(context.coordinator, action: #selector(Coordinator.handleSignUp), for: .touchUpInside)
        hStackView.addArrangedSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            // Pin the stack view to the safe area's top, and constrain its horizontal edges.
            stackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Position the pageLabel at the top of the stack view.
            pageLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            pageLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            pageLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            // Position the usernameInput below the pageLabel with a standard spacing.
            usernameInput.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            usernameInput.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            usernameInput.heightAnchor.constraint(equalToConstant: 40),
            
            passwordInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: 30),
                        
            hStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            hStackView.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            
        ])
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    class Coordinator: NSObject {
        var onForgotPassword: () -> Void
        var onSignUp: () -> Void
        var onSignIn: () -> Void
        
        weak var usernameInput: UITextField?
        weak var passwordInput: UITextField?
        
        init(onSignIn: @escaping () -> Void, onForgotPassword: @escaping () -> Void,
             onSignUp: @escaping () -> Void) {
            self.onSignIn = onSignIn
            self.onForgotPassword = onForgotPassword
            self.onSignUp = onSignUp
        }
        
        @objc func handleSignIn() {
                // Retrieve text from the stored text fields.
                guard let email = usernameInput?.text,
                      let password = passwordInput?.text else {
                    print("Username or password field is nil")
                    return
                }
                
                AuthManager.shared.signIn(email: email, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            self.onSignIn()
                            print("Sign In Success: \(user.uid)")
                        case .failure(let error):
                            print("Sign In Error: \(error.localizedDescription)")
                        }
                    }
                }
            }

        
        
        @objc func handleForgotPassword() {
            print("Forgot Password tapped")
            onForgotPassword()
        }
        
        @objc func handleSignUp() {
            print("Create Account tapped")
            onSignUp()
        }
    }
}
#Preview {
    LogInScreen()
}
