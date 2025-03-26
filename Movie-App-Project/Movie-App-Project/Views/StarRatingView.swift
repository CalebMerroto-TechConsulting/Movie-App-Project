//
//  starFill.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI
enum starFill {
    case full
    case half
    case empty
}

struct StarRatingView: View {
    @State var rating: Int
    var spacing: CGFloat = 0.5
    var scale: CGFloat = 20
    
    init(_ rating: Int,_ spacing: CGFloat = 0.5,_ scale: CGFloat = 20) {
        self.rating = rating
        self.spacing = spacing
        self.scale = scale
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            Star(fill: fill(2), scale: scale)
            Star(fill: fill(4), scale: scale)
            Star(fill: fill(6), scale: scale)
            Star(fill: fill(8), scale: scale)
            Star(fill: fill(10), scale: scale)
        }
        .foregroundStyle(.yellow)
    }
    func fill(_ f: Int) -> starFill {
        if rating >= f { return .full }
        else if rating >= (f - 1) {return .half}
        else {return .empty}
    }
}

struct Star: View {
    @State var fill: starFill
    var scale: CGFloat = 10
    var body: some View {
        switch fill {
            case .full:
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: scale)
            case .half:
                Image(systemName: "star.leadinghalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: scale)
            case .empty:
                Image(systemName: "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: scale)
        }
            
    }
    
}

#Preview {
    StarRatingView(1)
    StarRatingView(2)
    StarRatingView(3)
    StarRatingView(4)
    StarRatingView(5)
    StarRatingView(6)
    StarRatingView(7)
    StarRatingView(8)
    StarRatingView(9)
    StarRatingView(10)
}
