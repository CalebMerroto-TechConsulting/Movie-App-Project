//
//  Movie.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


struct Movie: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Ratings: [RatingSource]
    let BoxOffice: String?
    
    var starRating: Int {
        guard !Ratings.isEmpty else { return 0 }
        let total = Ratings.reduce(0) { $0 + $1.value }
        return total / Ratings.count
    }
}
struct RatingSource: Decodable, Identifiable {
    let Source: String
    let Value: String
    var id: String { Source }
    var value: Int {
        if Value.contains("/") {
            // For ratings like "7.0/10" or "57/100"
            let components = Value.split(separator: "/")
            if let scoreStr = components.first, let score = Double(scoreStr) {
                return Int(score.rounded())
            }
        } else {
            // For ratings like "77%"
            let percentStr = Value.replacingOccurrences(of: "%", with: "")
            if let percent = Double(percentStr) {
                return Int((percent / 10).rounded())
            }
        }
        return 0
    }
    
}
