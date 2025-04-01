//
//  SignOutAndProfileButtonView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/28/25.
//

import SwiftUI

struct SignOutAndProfileButtonView: View {
    @Binding var showAlert: Bool
    @State var showProfile = false
    @State var img: UIImage = ProfileManager.shared.profileImage
    @State var username: String = ProfileManager.shared.username
    init(_ showAlert: Binding<Bool>) {
        self._showAlert = showAlert
    }
    var body: some View {
        HStack {
            Button(action: {
                showAlert = true
            }) {
                Text("Sign Out")
                    .foregroundStyle(.blue)
            }
            Spacer()
            Button(action: {
                showProfile = true
            }) {
                HStack{
                    Text("\(username != "" ? username : "User")")
                    ProfileImageView($img, 40)
                }
            }
        }
        .padding(.horizontal, 15)
        .navigationDestination(isPresented: $showProfile) {
            ProfileView()
        }
        .onAppear {
            ProfileManager.shared.loadProfile() {
                img = ProfileManager.shared.profileImage
                username = ProfileManager.shared.username
            }
        }
    }
}

#Preview {
    SignOutAndProfileButtonView(.constant(false))
}
