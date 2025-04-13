import Foundation

class NetworkManager:NSObject,NetWorkManagerProtocol{
     func getNewsFeedFromAPI(getNewsFeed: GetNewsFeed) async throws -> Response {
        let request = try ApiRouter.getNewsFeed(getNewsFeed: getNewsFeed).asURLRequest()
        return try await BaseApiClient.request(urlRequest: request, errorType: ErrorModel.self)
    }
}
//MARK:- API
protocol NetWorkManagerProtocol{
    func getNewsFeedFromAPI(getNewsFeed: GetNewsFeed) async throws -> Response
}
