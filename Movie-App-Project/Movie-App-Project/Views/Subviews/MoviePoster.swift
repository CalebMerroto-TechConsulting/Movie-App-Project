//
//  MoviePoster.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//
// movieGridView is crashing whenever it is given more than one movie to load, the crash occurs immediately, and does not wait for any UI events.


import SwiftUI

struct MoviePoster: View {
    @State var url: String
    @State var width: CGFloat
    @State var aspectRatio: (CGFloat, CGFloat) // reduced fraction for aspect ratio
    @StateObject var vm = ImageVM()
    @State var isLoading = false
    @State var err = false
    
    var placeholder: UIImage {
            let height = width * (aspectRatio.1 / aspectRatio.0)
            let size = CGSize(width: width, height: height)
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { context in
                UIColor.lightGray.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
    
    var body: some View {
            Group {
                if let img = vm.data {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(aspectRatio.0 / aspectRatio.1, contentMode: .fit)
                } else {
                    ZStack {
                        Image(uiImage: placeholder)
                            .resizable()
                            .aspectRatio(aspectRatio.0 / aspectRatio.1, contentMode: .fit)
                        ProgressView()
                    }
                }
            }
            .frame(width: width)
            .task {
                isLoading = true
                if url != "" {
                    await vm.fetch(url)
                }
                isLoading = false
            }
        }
    }

    #Preview {
        MoviePoster(
            url: "https://m.media-amazon.com/images/M/MV5BNjRhNGZjZjEtYTQzYS00OWUxLThjNGEtMTIwMTE2ZDFlZTZkXkEyXkFqcGc@._V1_SX300.jpg",
            width: 300,
            aspectRatio: (2, 3)
        )
    }
