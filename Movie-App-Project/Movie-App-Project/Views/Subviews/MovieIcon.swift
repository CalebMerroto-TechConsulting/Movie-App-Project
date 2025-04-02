//
//  MovieIcon.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

struct MovieIcon: View {
    @EnvironmentObject var user: ProfileManager
    @StateObject var vm = ViewModel<Movie>()
    @State var url: String
    var iconWidth: CGFloat = 170
    @State var isFavorite: Bool = false
    @State var showInfo: Bool = false

    var body: some View {
        VStack {
            if let movie = vm.data {
                ZStack {
                    // Invisible NavigationLink covering the whole cell.
                    VStack {
                        MoviePoster(url: movie.Poster, width: iconWidth, aspectRatio: (2, 3))
                        StarRatingView(movie.starRating)
                    }
                    .contentShape(Rectangle())
                    .background(.black)
                    .cornerRadius(15)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 2)
                    )
                    .onTapGesture(perform: {
                        showInfo = true
                    })
                    .navigationDestination(isPresented: $showInfo) {
                        MovieInfoView(url: url)
                    
                    }

                    

                    // Favorite button overlay.
                    VStack {
                        HStack {
                            Spacer()
                            FavoriteButton(user: user, title: movie.Title, isFavorite: $isFavorite)
                        }
                        Spacer()
                    }
                    .frame(width: iconWidth, height: iconWidth + iconWidth * (2/3))
                }
                Text(movie.Title)
                    .font(.system(size: 15, weight: .bold))
                    .frame(width: iconWidth, height: 44, alignment: .center)
                    .lineLimit(2)
            } else if let err = vm.error {
                // Error view.
                VStack {
                    Text(err.message)
                        .foregroundColor(.red)
                }
                .frame(width: iconWidth, height: iconWidth + iconWidth * (2/3))
                .background(Color.red.opacity(0.2))
                .cornerRadius(15)
                Text("ERROR")
                    .font(.system(size: 15, weight: .bold))
                    .frame(width: iconWidth, height: 44, alignment: .center)
                    .lineLimit(2)
            } else {
                // Placeholder view.
                VStack {
                    MoviePoster(url:"", width: iconWidth, aspectRatio: (2, 3))
                    StarRatingView(0)
                }
                .background(Color.black)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                Text("Movie Title")
                    .font(.system(size: 15, weight: .bold))
                    .frame(width: iconWidth, height: 44, alignment: .center)
                    .lineLimit(2)
            }
        }
        .task {
            await vm.fetch(url)
            isFavorite = user.favorites.contains(vm.data?.Title ?? "")
        }
    }
}

#Preview {
    let url = OMDBURL("Iron Man")
    let errurl = "https://www.omdbapi.com/?t=Tr8&apikey=aef8b2b6"
    NavigationStack{
        HStack {
            MovieIcon(url: url)
            MovieIcon(url: errurl)
        }
    }
    .environmentObject(ProfileManager.shared)
}
