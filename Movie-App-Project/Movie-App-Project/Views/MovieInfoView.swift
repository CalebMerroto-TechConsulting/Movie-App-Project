//
//  MovieInfoView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

struct MovieInfoView: View {
    @StateObject var vm = ViewModel<Movie>()
    let url: String
    var body: some View {
        VStack {
            if let movie = vm.data {
                Text(movie.Title)
                    .font(.system(size: 32, weight: .bold))
                
                HStack {
                    MoviePoster(url: movie.Poster, width: 200, aspectRatio: (2,3))
                    VStack {
                        Spacer()
                        HStack{
                            StarRatingView(movie.starRating)
                            Spacer()
                        }
                        LabelVal("Rating",movie.Rated)
                        LabelVal("Released",movie.Year)
                        LabelVal("Runtime",movie.Runtime)
                        LabelVal("Country", movie.Country)
                        VStack {
                            ForEach(movie.Ratings) { rating in
                                switch rating.Source.lowercased() {
                                    case "internet movie database":
                                        HStack {
                                            LogoView(logo: .imdb)
                                            Text(rating.Value)
                                            Spacer()
                                        }
                                    case "rotten tomatoes":
                                        HStack {
                                            LogoView(logo: .rottenTomatos)
                                            Text(rating.Value)
                                            Spacer()
                                        }
                                    case "metacritic":
                                        HStack {
                                            LogoView(logo: .metacritic)
                                            Text(rating.Value)
                                            Spacer()
                                        }
                                    default:
                                        EmptyView()
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        Spacer()
                    }
                    .frame(width: 150)
                    
                }
                .frame(height: 300)
                .padding()
                if movie.Genre != "N/A" {
                    Text(movie.Genre.replacingOccurrences(of: ",", with: " | "))
                }
                HStack(alignment: .top, spacing: 30) {
                    VStack(alignment: .leading) {
                        if movie.Director != "N/A" {
                            Text("Director: ")
                                .font(.headline)
                                .fontWeight(.bold)
                            HStack {
                                Text(" •")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(movie.Director)
                            }
                        }
                        if movie.Language != "N/A" {
                            Text(!movie.Language.contains(",") ? "Language" : "Original Language")
                                .font(.headline)
                                .fontWeight(.bold)
                            HStack {
                                Text(" •")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(movie.Language.contains(",") ? String(movie.Language.split(separator: ",").first!): movie.Language)
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Cast:")
                            .font(.headline)
                            .fontWeight(.bold)
                        ForEach(movie.Actors.split(separator: ",").map {
                            String($0).trimmingCharacters(in: .whitespaces)
                        }, id: \.self) { person in
                            HStack {
                                Text(" •")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(person)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 2)
                VStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        Text(":Plot:")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    Text(movie.Plot)
                    if movie.Awards != "N/A" {
                        VStack(alignment: .leading) {
                            Text(":Awards:")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        Text(movie.Awards)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            Spacer()
        }
        .task {
            await vm.fetch(url)
        }
    }
}

#Preview {
//    MovieInfoView(url: OMDBURL("My Hero Academia: Heroes Rising"))
    MovieInfoView(url: OMDBURL("The Avengers"))
}
