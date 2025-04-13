import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// Parameters type alias for query parameters or body
typealias Parameters = [String: Any]


enum ApiRouter {
    case getNewsFeed(getNewsFeed: GetNewsFeed)

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.baseUrl!)!
        var urlRequest = URLRequest(url: (url.appendingPathComponent(path)))

        // HTTP method
        urlRequest.httpMethod = method.rawValue

       
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        switch method {
        case .get:
            if let params = parameters {
                // Encode GET parameters manually into the URL
                urlRequest.url = try encodeGetParameters(urlRequest.url!, params: params)
            }
        case .post:
            if let params = parameters {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
        default:
            break
        }

        return urlRequest
    }

    // MARK: - HTTP Method
    private var method: HTTPMethod {
        switch self {
        case .getNewsFeed:
            return .get
        }
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .getNewsFeed(let getNewsFeed):
            return URLModifier.ModifiedGetNewsFeedUrl(getNewsFeed: getNewsFeed)
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getNewsFeed(let newsFeed):
            return [Constants.Parameters.apiKey: newsFeed.apiKey]
        }
    }

    // MARK: - Encode GET parameters into URL
    private func encodeGetParameters(_ url: URL, params: Parameters) throws -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        return components.url!
    }

   
    
}
