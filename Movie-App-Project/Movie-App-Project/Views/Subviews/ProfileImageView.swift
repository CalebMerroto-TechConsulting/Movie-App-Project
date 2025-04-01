//
//  ProfileImageView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/28/25.
//

import SwiftUI

struct ProfileImageView: View {
    @Binding var img: UIImage
    let size: CGFloat
    var radius: CGFloat { size / 2 }
    
    init(_ img: Binding<UIImage>,_ size: CGFloat){
        self._img = img
        self.size = size
    }
    var body: some View {
        Image(uiImage: img)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .background(.gray)
            .cornerRadius(radius)
    }
}

#Preview {
    ProfileImageView(.constant(UIImage(systemName: "person.circle")!), 200)
}
