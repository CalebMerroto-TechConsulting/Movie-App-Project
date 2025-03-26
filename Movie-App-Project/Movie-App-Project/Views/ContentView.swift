//
//  ContentView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
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
}

#Preview {
    ContentView()
        .environmentObject(FavoritesManager.shared)
}
