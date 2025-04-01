//
//  Movie_App_ProjectApp.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI
import FirebaseCore

@main
struct Movie_App_ProjectApp: App {
    init() {
        FirebaseApp.configure()
        
        if let app = FirebaseApp.app() {
            print("Firebase configured: \(app)")
        } else {
            print("Firebase configuration failed – no FirebaseApp instance!")
        }
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            print("Found Firebase config at: \(path)")
        } else {
            print("Firebase config not found!")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ProfileManager.shared)
        }
    }
}
