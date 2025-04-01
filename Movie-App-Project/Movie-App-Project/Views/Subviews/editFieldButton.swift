//
//  editFieldButton.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/28/25.
//

import SwiftUI
import PhotosUI

struct editFieldButton: View {
    @State var selectedImage: PhotosPickerItem? = nil
    @Binding var img: UIImage
    let size: CGFloat
    var radius: CGFloat { size / 2 }
    private let defaultImg = UIImage(systemName: "person.circle")!
    let isImagePicker: Bool
    let action: () -> Void
    
    init(size: CGFloat, img: Binding<UIImage>) {
        self.size = size
        self._img = img
        self.isImagePicker = true
        self.action = {}
    }
    
    init(size: CGFloat, action: @escaping () -> Void) {
        self.size = size
        self._img = .constant(UIImage(systemName: "square.and.pencil.circle")!)
        self.isImagePicker = false
        self.action = action
    }
    var body: some View {
        Group {
            if isImagePicker {
                PhotosPicker(
                    selection: $selectedImage,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    editFieldImage(size, radius)
                }
            } else {
                Button(action: {
                    action()
                }) {
                    editFieldImage(size, radius)
                }
            }
        }
        .onChange(of: selectedImage) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    img = UIImage(data: data) ?? defaultImg
                    ProfileManager.shared.setProfileImage(img)
                }
            }
        }
    }
}
struct editFieldImage: View {
    let size: CGFloat
    let radius: CGFloat
    
    init(_ size: CGFloat,_ radius: CGFloat) {
        self.size = size
        self.radius = radius
    }
    
    var body: some View {
        Image(systemName: "square.and.pencil.circle")
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .background(.white)
            .cornerRadius(radius)
            .padding(3)
    }
}
#Preview {
    editFieldButton(size: 100, img: .constant(UIImage(systemName: "square.and.pencil.circle")!))
}
