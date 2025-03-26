//
//  movieNames.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


struct movieNames: Decodable {
    struct searchResult: Decodable {
        let info: [Item]
        let results: [Item]
    }
    let similar: searchResult
    var movies: [Item] {
        var uniqueItems: [Item] = []
        for item in (similar.info + similar.results) {
            if !uniqueItems.contains(where: { $0 == item }) {
                uniqueItems.append(item)
            }
        }
        return uniqueItems
    }
}
struct Item: Decodable, Identifiable, Equatable {
    let name: String
    var id: String { name }
    
}
