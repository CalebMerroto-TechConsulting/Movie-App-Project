//
//  MovieSearchView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

struct MovieSearchView: View {
    @State var searchText: String = "Thor"
    @State var isLoading: Bool = false
    @StateObject var TasteDiveVM = ViewModel<MovieNames>()
    
    var body: some View {
        VStack {
            Text("Search By Title")
                .font(.system(size: 24, weight: .bold))
            TextField("Search", text: $searchText)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding()
                .onSubmit {
                    Task {
                        await TasteDiveVM.fetch(tasteDiveURL(searchText))
                    }
                }
            
            if let data = TasteDiveVM.data {
                MovieGridView(movies: data.movies)
            }
            Spacer()
        }
        .task {
            await TasteDiveVM.fetch(tasteDiveURL(searchText))
        }
    }
    
    
}

#Preview {
    MovieSearchView()
        .environmentObject(ProfileManager.shared)
}
