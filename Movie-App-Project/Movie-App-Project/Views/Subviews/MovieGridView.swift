//
//  MovieGridView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

struct MovieGridView: View {
    var movies: [Item]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(movies) { movie in
                    MovieIcon(url: OMDBURL(movie.name), iconWidth: 150)
                        .onAppear() {
                            print(OMDBURL(movie.name))
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let movies = [
        Item(name: "Captain America: The First Avenger"),
        Item(name: "Iron Man"),
        Item(name: "The Incredible Hulk"),
        Item(name: "Thor"),
        Item(name: "Iron Man 3"),
        Item(name: "Captain America: The Winter Soldier"),
        Item(name: "Hulk"),
        Item(name: "Avengers: Age of Ultron"),
        Item(name: "Avengers: Infinity War"),
        Item(name: "Thor: The Dark World"),
        Item(name: "Captain Marvel"),
        Item(name: "Fantastic Four"),
        Item(name: "Spider-Man"),
        Item(name: "Guardians of the Galaxy"),
        Item(name: "X-Men"),
        Item(name: "Fantastic Four: Rise of the Silver Surfer"),
        Item(name: "Spider-Man 3"),
        Item(name: "X-Men: The Last Stand"),
        Item(name: "X-Men Origins: Wolverine"),
        Item(name: "The Amazing Spider-Man")
    ]
    MovieGridView(movies: movies)
        .environmentObject(ProfileManager.shared)
}
