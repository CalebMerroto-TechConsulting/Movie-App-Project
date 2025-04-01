//
//  ProfileView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/28/25.
//

import SwiftUI

struct ProfileView: View {
    /// **UI Constants**
    private var imageSize: CGFloat = 150
    private var newImgBtnDiv: CGFloat = 4
    private var profile = ProfileManager.shared
    
    /// **UI Controls**
    @State var editingUsername: Bool = false
    
    /// **Profile Fields**
    @State var img: UIImage = ProfileManager.shared.profileImage
    @State var username: String = ProfileManager.shared.username
    @State var favorites: [String] = ProfileManager.shared.favorites
    @State var email: String = ProfileManager.shared.email

    var body: some View {
        VStack {
            ZStack{
                ProfileImageView($img, imageSize)
                
                HStack {
                    Spacer()
                    VStack{
                        Spacer()
                        editFieldButton(size: imageSize / newImgBtnDiv, img: $img)
                    }
                }
                .frame(maxWidth: imageSize, maxHeight: imageSize)
            }
            HStack {
                if !editingUsername {
                    Text("\(username != "" ? username : "User")")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.leading, 44)
                    editFieldButton(size: 32) { editingUsername = true }
                }
                else {
                    TextField("\(username != "" ? username : "Username")", text: $username)
                        .frame(width: 300, alignment: .center)
                        .padding()
                        .font(.system(size: 25, weight: .bold))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black)
                        }
                        .onSubmit {
                            editingUsername = false
                            if username != "" {
                                profile.setUsername(username)
                            }
                        }
                }
            }
            Text(email)
                .foregroundStyle(.gray)
            VStack {
                Text("\(favorites.count) Favorited Movies")
                    .font(.system(size: 25, weight: .bold))
                List {
                    ForEach(favorites, id: \.self) { fav in
                        Text(fav)
                    }
                }
            }
            .padding(.vertical, 30)
            .frame(width: 300, alignment: .center)
            Spacer()
        }
        .padding(.top, 30)
        .onAppear {
            ProfileManager.shared.loadProfile() {
                img = ProfileManager.shared.profileImage
                username = ProfileManager.shared.username
                favorites = ProfileManager.shared.favorites
                email = ProfileManager.shared.email
            }
        }
    }
}

#Preview {
    ProfileView()
}
