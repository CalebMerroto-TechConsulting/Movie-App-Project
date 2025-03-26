//
//  FavoritesView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesManager
    @State var favoritedMovies: [Item] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Favorites")
                    .font(.system(size: 32, weight: .bold))
                    .padding()
                MovieGridView(movies: .constant(favoritedMovies))
            }
            .onAppear() {
                favoritedMovies = favorites.getFavorites().map { movieName in
                    Item(name: movieName)
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager.shared)
}
