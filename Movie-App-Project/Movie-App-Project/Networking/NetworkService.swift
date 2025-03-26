//
//  NetworkService.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import Foundation

protocol NetworkService {
    func get(url: String) async throws -> Data?
}

enum APIError: Error {
    case InvalidURL(msg: String)
    case NetworkError(msg: String)
    case NoData
    case Unknown(msg: String)
    case decodingError(msg: String)
    case RequestError(msg: String)
    
    var msg: String {
        switch self {
            case .InvalidURL(let msg):
                return msg
            case .NetworkError(let msg):
                return msg
            case .decodingError(let msg):
                return msg
            case .RequestError(let msg):
                return msg
            case .NoData:
                return "No Data"
            case .Unknown(msg: let msg):
                return msg
        }
    }
}
