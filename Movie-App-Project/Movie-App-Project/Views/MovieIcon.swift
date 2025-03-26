//
//  MovieIcon.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

struct MovieIcon: View {
    @EnvironmentObject var favorites: FavoritesManager
    @StateObject var vm = ViewModel<Movie>()
    @State var url: String
    var iconWidth: CGFloat = 170
    @State var isFavorite: Bool = false

    var body: some View {
        VStack {
            if let movie = vm.data {
                ZStack {
                    // NavigationLink covers entire area
                    NavigationLink(destination: MovieInfoView(url: url)) {
                        VStack {
                            MoviePoster(url: movie.Poster, width: iconWidth, aspectRatio: (2, 3))
                            StarRatingView(movie.starRating)
                        }
                        .contentShape(Rectangle()) // Ensure entire area is tappable
                    }
                    .background(.black)
                    .cornerRadius(15)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 2)
                    )
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                if isFavorite {
                                    favorites.removeFavorite(movie.Title)
                                } else {
                                    favorites.addFavorite(movie.Title)
                                }
                                isFavorite = favorites.isFavorite(movie.Title)
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                    .padding(10)
                                    .background(Color.white.opacity(0.4))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                    }
                    .frame(width: iconWidth, height: iconWidth + iconWidth * (2/3))
                }
                VStack {
                    Text(movie.Title)
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: iconWidth, height: 44, alignment: .center)
                        .lineLimit(2)
                    Spacer()
                }
                .frame(width: iconWidth, height: 44, alignment: .center)
            } else if let err = vm.error {
                Text(err.msg)
                    .foregroundColor(.red)
                    .frame(width: iconWidth, height: iconWidth + iconWidth * (2/3))
                    .cornerRadius(15)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red, lineWidth: 2)
                    )
                
                VStack {
                    Text("ERROR")
                        .foregroundColor(.red)
                        .font(.headline)
                        .frame(width: iconWidth, height: 44, alignment: .center)
                        .lineLimit(2)
                    Spacer()
                }
                .frame(width: iconWidth, height: 44, alignment: .center)
            } else {
                // Placeholder content
                VStack {
                    MoviePoster(url:"", width: iconWidth, aspectRatio: (2, 3))
                    StarRatingView(0)
                }
                .background(Color.black)
                .cornerRadius(15)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                Text("Movie Title")
                    .font(.headline)
            }
        }
        .task {
            await vm.fetch(url)
            isFavorite = favorites.isFavorite(vm.data?.Title ?? "")
        }
    }
}

#Preview {
    let url = "https://www.omdbapi.com/?t=Avengers%20Age%20of%20Ultron&apikey=aef8b2b6"
    let errurl = "https://www.omdbapi.com/?t=Tr8&apikey=aef8b2b6"
    
    HStack {
        MovieIcon(url: url)
        MovieIcon(url: errurl)
    }
    .environmentObject(FavoritesManager.shared)
}
