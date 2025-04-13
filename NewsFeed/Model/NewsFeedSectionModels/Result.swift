import Foundation

// MARK: - Result
class Result: Codable {
    let uri: String?
    let url: String?
    let id: Int?
    let assetID: Int?
    let publishedDate: String?
    let updated: String?
    let section: String?
    let subsection: String?
    let nytdsection: String?
    let adxKeywords: String?
    let byline: String?
    let type: String?
    let title: String?
    let abstract: String?
    let media: [Media]?
    let etaID: Int?

    enum CodingKeys: String, CodingKey {
        case uri, url, id
        case assetID = "asset_id"
        case publishedDate = "published_date"
        case updated, section, subsection, nytdsection
        case adxKeywords = "adx_keywords"
        case byline, type, title, abstract
        case media
        case etaID = "eta_id"
    }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            uri = try container.decodeIfPresent(String.self, forKey: .uri)
            url = try container.decodeIfPresent(String.self, forKey: .url)
            id = try container.decodeIfPresent(Int.self, forKey: .id)
            assetID = try container.decodeIfPresent(Int.self, forKey: .assetID)
            publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
            updated = try container.decodeIfPresent(String.self, forKey: .updated)
            section = try container.decodeIfPresent(String.self, forKey: .section)
            subsection = try container.decodeIfPresent(String.self, forKey: .subsection)
            nytdsection = try container.decodeIfPresent(String.self, forKey: .nytdsection)
            adxKeywords = try container.decodeIfPresent(String.self, forKey: .adxKeywords)
            byline = try container.decodeIfPresent(String.self, forKey: .byline)
            type = try container.decodeIfPresent(String.self, forKey: .type)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
            media = try container.decodeIfPresent([Media].self, forKey: .media)
            etaID = try container.decodeIfPresent(Int.self, forKey: .etaID)
        }
    
    
}
