import Foundation

// MARK: - MediaMetadatum
class MediaMetadatum: Codable {
    let url:    String?
    let format: String?
    let height: Int?
    let width : Int?
    
    enum CodingKeys: String, CodingKey {
        case url, format, height, width
    }

   

    // Encoding and decoding functions for Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        format = try container.decodeIfPresent(String.self, forKey: .format)
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        
    }
}
