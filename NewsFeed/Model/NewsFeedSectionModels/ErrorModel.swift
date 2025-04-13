

import Foundation

// MARK: - ResponseGeneral
struct ErrorModel: Codable {
    var fault: ErrorRespose?
    let progress: Double?
}

struct ErrorRespose: Codable {
    var faultstring: String?
    let detail: Detail?
}

struct Detail: Codable {
    let errorcode: String?
}

struct GenericError: Codable {
    let message: String
}
