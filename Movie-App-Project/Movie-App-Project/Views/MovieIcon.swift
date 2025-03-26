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
                    VStack {
                        MoviePoster(url: movie.Poster, width: iconWidth, aspectRatio: (2, 3))
                        StarRatingView(movie.starRating)
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
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.red)
                                .padding(10)
                                .background(.white.opacity(0.4))
                                .cornerRadius(15)
                                .onTapGesture {
                                    if isFavorite { favorites.removeFavorite(movie.Title)
                                    }
                                    else {
                                        favorites.addFavorite(movie.Title)
                                    }
                                    isFavorite = favorites.isFavorite(vm.data?.Title ?? "")
                                }
                        }
                        Spacer()
                    }
                    .frame(width: iconWidth, height: (iconWidth + iconWidth * (2/3)))
                    
                }
                VStack {
                    Text(movie.Title)
                        .font(.headline)
                        .frame(width: iconWidth, height: 44, alignment: .center)
                        .lineLimit(2)
                    Spacer()
                }
                .frame(width: iconWidth, height: 44, alignment: .center)
            } else if let err = vm.error {
                Text(err.msg)
                    .foregroundStyle(.red)
                    .frame(width: iconWidth, height: (iconWidth + iconWidth * (2/3)))
                    .cornerRadius(15)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.red, lineWidth: 2)
                    )
                
                VStack {
                    Text("ERROR")
                        .foregroundStyle(.red)
                        .font(.headline)
                        .frame(width: iconWidth, height: 44, alignment: .center)
                        .lineLimit(2)
                    Spacer()
                }
                .frame(width: iconWidth, height: 44, alignment: .center)
            } else {
                // Show placeholder content
                VStack {
                    MoviePoster(url: "", width: iconWidth, aspectRatio: (2, 3))
                    StarRatingView(0)
                }
                .background(.black)
                .cornerRadius(15)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 2)
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
        MovieIcon(url: url)         // success example
        MovieIcon(url: errurl)      // error example
    }
    .environmentObject(FavoritesManager.shared)
}
