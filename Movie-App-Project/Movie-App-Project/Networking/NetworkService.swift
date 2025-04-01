import Foundation

protocol NetworkService {
    func get(url: String) async throws -> Data?
}

enum APIError: Error, LocalizedError {
    case invalidURL(message: String)
    case networkError(message: String)
    case noData
    case unknown(message: String)
    case decodingError(message: String)
    case requestError(message: String)
    
    var message: String {
        switch self {
        case .invalidURL(let message),
             .networkError(let message),
             .decodingError(let message),
             .requestError(let message),
             .unknown(let message):
            return message
        case .noData:
            return "No Data"
        }
    }
    
    var errorDescription: String? {
        return message
    }
}
