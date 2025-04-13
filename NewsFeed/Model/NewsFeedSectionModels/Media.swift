
import Foundation



// MARK: - Media
class Media: Codable {
    let type: String?
    let subtype: String?
    let caption: String?
    let copyright: String?
    let approvedForSyndication : Int?
    let mediaMetadata : [MediaMetadatum]?

    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }

   

    // Initializer to create from decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        subtype = try container.decodeIfPresent(String.self, forKey: .subtype)
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        approvedForSyndication = try container.decodeIfPresent(Int.self, forKey: .approvedForSyndication) ?? -1
        mediaMetadata = try container.decodeIfPresent([MediaMetadatum].self, forKey: .mediaMetadata) ?? []
        
        
    }

  
}

