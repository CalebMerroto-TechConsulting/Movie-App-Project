//
//  CreateAccountView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import SwiftUI
import FirebaseCore

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRetype: String = ""
    @State private var errorMessage: String? = nil
    @State private var isSigningUp: Bool = false
    @State private var isSignedUp: Bool = false
    let onBack: () -> Void

    var body: some View {
        NavigationStack {
            HStack {
                Button(action: {
                    onBack()
                }) {
                    Text("< Back")
                        .foregroundStyle(.blue)
                        .padding()
                }
                Spacer()
            }
            VStack(spacing: 50) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 30) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    VStack(spacing: 16) {
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Retype Password", text: $passwordRetype)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    guard !password.isEmpty, password == passwordRetype else {
                        errorMessage = "Passwords do not match or are empty."
                        return
                    }
                    
                    isSigningUp = true
                    
                    // Save the username for internal use.
                    UserDefaults.standard.set(email, forKey: "Username")
                    
                    // Call Firebase Auth through your AuthManager.
                    AuthManager.shared.signUp(email: email, password: password) { result in
                        DispatchQueue.main.async {
                            isSigningUp = false
                            switch result {
                            case .success(let user):
                                print("Sign Up Success: \(user.uid)")
                                isSignedUp = true   // Successfully signed up; trigger navigation.
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                print("Sign Up Error: \(error)")
                            }
                        }
                    }
                }) {
                    Text("Submit")
                        .frame(maxWidth: 375)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(7)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .disabled(isSigningUp)
                
                
                Spacer()
            }
            .padding(.top, 80)
        }
        .navigationDestination(isPresented: $isSignedUp) {
            ContentView()
        }
    }
}

#Preview {
    CreateAccountView(onBack: {})
}
