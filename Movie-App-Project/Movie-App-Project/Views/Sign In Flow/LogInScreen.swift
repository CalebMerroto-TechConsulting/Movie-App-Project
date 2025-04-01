//
//  LogInScreen.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import SwiftUI
import UIKit

struct LogInScreen: UIViewRepresentable {
    var onForgotPassword: () -> Void = {}
    var onSignUp: () -> Void = {}
    var onSignIn: () -> Void = {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSignIn: onSignIn, onForgotPassword: onForgotPassword, onSignUp: onSignUp)
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        // Create a vertical stack view that will hold all subviews.
        let stackView = UIStackView(arrangedSubviews: [
            createPageLabel(text: "Sign In"),
            createTextField(
                placeholder: "email",
                isSecure: false
            ),
            createTextField(
                placeholder: "Password",
                isSecure: true
            ),
            createButton(
                title: "Sign In",
                backgroundColor: .systemBlue,
                titleColor: .white,
                height: 44,
                target: context.coordinator,
                action: #selector(Coordinator.handleSignIn)
            ),
            createHorizontalStackView(
                with: [
                    createButton(
                        title: "Forgot Password",
                        backgroundColor: .white,
                        titleColor: .systemBlue,
                        target: context.coordinator,
                        action: #selector(Coordinator.handleForgotPassword)
                    ),
                    createButton(
                        title: "Create Account",
                        backgroundColor: .white,
                        titleColor: .systemBlue,
                        target: context.coordinator,
                        action: #selector(Coordinator.handleSignUp)
                    )
                ]
            ),
            createErrorLabel()
        ])
        stackView.axis = .vertical
        stackView.spacing = 60
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Assign the text fields and error label to the coordinator.
        if let usernameInput = stackView.arrangedSubviews[1] as? UITextField,
           let passwordInput = stackView.arrangedSubviews[2] as? UITextField,
           let errorLabel = stackView.arrangedSubviews.last as? UILabel {
            context.coordinator.usernameInput = usernameInput
            context.coordinator.passwordInput = passwordInput
            context.coordinator.errorLabel = errorLabel
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    // MARK: - Helper UI Creation Methods
    
    private func createPageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }
    
    private func createTextField(placeholder: String, isSecure: Bool) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }
    
    private func createButton(title: String, backgroundColor: UIColor, titleColor: UIColor, height: CGFloat = 44, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    private func createHorizontalStackView(with subviews: [UIView]) -> UIStackView {
        let hStack = UIStackView(arrangedSubviews: subviews)
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        return hStack
    }
    
    private func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemRed
        label.numberOfLines = 10
        label.textAlignment = .center
        return label
    }
        
    class Coordinator: NSObject {
        var onForgotPassword: () -> Void
        var onSignUp: () -> Void
        var onSignIn: () -> Void
        
        weak var usernameInput: UITextField?
        weak var passwordInput: UITextField?
        weak var errorLabel: UILabel?
        
        init(onSignIn: @escaping () -> Void, onForgotPassword: @escaping () -> Void, onSignUp: @escaping () -> Void) {
            self.onSignIn = onSignIn
            self.onForgotPassword = onForgotPassword
            self.onSignUp = onSignUp
        }
        
        @objc func handleSignIn() {
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
                        self.errorLabel?.text = ""
                    case .failure(let error):
                        print("Sign In Error: \(error.localizedDescription)")
                        self.errorLabel?.text = "Sign In Error: \(error.localizedDescription)"
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
