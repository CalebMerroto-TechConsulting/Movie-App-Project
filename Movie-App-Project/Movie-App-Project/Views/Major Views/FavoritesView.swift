//
//  FavoritesView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: ProfileManager
    @State var favoritedMovies: [Item] = []
    
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.system(size: 32, weight: .bold))
                .padding()
            MovieGridView(movies: favoritedMovies)
        }
        .onAppear {
            favoritedMovies = favorites.favorites.map { movieName in
                Item(name: movieName)
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(ProfileManager.shared)
}
