//
//  ContentView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


import SwiftUI


enum LoginFlowState {
    case SignIn
    case ForgotPassword
    case SignUp
}

struct ContentView: View {
    @State private var showingScreen: LoginFlowState = .SignIn
    @State var signedIn = false
    var body: some View {
        NavigationStack {
            if signedIn {
                NavigationStack {
                    TabView {
                        MovieSearchView()
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                            }
                        FavoritesView()
                            .tabItem {
                                Image(systemName: "heart.fill")
                            }
                    }
                    .padding()
                }
            } else {
                switch showingScreen {
                    case .SignIn:
                        LogInScreen(
                            onForgotPassword: { showingScreen = .ForgotPassword },
                            onSignUp: { showingScreen = .SignUp },
                            onSignIn: { signedIn = true }
                        )
                    case .ForgotPassword:
                        ForgotPasswordView(onBack: { showingScreen = .SignIn })
                    case .SignUp:
                        CreateAccountView(onBack: { showingScreen = .SignIn })
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesManager.shared)
}
