//
//  FavoriteButton.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 4/1/25.
//

import SwiftUI

struct FavoriteButton: View {
    @ObservedObject var user: ProfileManager
    let title: String
    @Binding var isFavorite: Bool
    var body: some View {
        Button {
            if isFavorite {
                user.removeFavorite(title)
            } else {
                user.addFavorite(title)
            }
            isFavorite = user.favorites.contains(title)
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
}

#Preview {
    FavoriteButton(user: ProfileManager.shared, title: "Iron Man", isFavorite: .constant(false))
}
