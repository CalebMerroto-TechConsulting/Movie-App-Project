//
//  LogoView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI
enum Logo: String, RawRepresentable {
    case metacritic = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Metacritic_logo_Roundel.svg/640px-Metacritic_logo_Roundel.svg.png"
    case imdb = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/IMDb_Logo_Rectangle.svg/512px-IMDb_Logo_Rectangle.svg.png?20200218171647"
    case rottenTomatos = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Rotten_Tomatoes.svg/1200px-Rotten_Tomatoes.svg.png"
}
struct LogoView: View {
    @StateObject var vm = ImageVM()
    @State var logo: Logo
    var body: some View {
        Group {
            if let img = vm.data {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            } else {
                ProgressView()
            }
        }
        .task {
            await vm.fetch(logo.rawValue)
        }
    }
}

#Preview {
    LogoView(logo: .imdb)
    LogoView(logo: .metacritic)
    LogoView(logo: .rottenTomatos)
}
