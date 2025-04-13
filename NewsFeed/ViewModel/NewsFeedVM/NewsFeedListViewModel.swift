

import Foundation
import Combine

class NewsFeedListViewModel:BaseViewModel{
    
    //Controller Variables
    var resutlsArray:[Result]? = []
    
    //Bindings Variables
    var responseNewsFeed: Box<Response?> = Box(nil)
    var responseNewsFeedError: Box<ErrorModel?> = Box(nil)
    var responseNewsFeedExpiryObserver: Box<ErrorModel?> = Box(nil)
    
    // MARK: - API Calls
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func getNewsFeedApi(getNewsFeed: GetNewsFeed) {
        Task {
            do {
                let response = try await networkManager.getNewsFeedFromAPI(getNewsFeed: getNewsFeed)
                self.responseNewsFeed.value = response
                self.completeResponse.value = -1
            } catch let error as ApiError<ErrorModel> {
                self.handleError(
                    data: error,
                    errorObserver: self.responseNewsFeedError,
                    expireObserver: self.responseNewsFeedExpiryObserver,
                    statusCodeObserver: self.errorStatusCode
                )
            } catch {
                let unknownError = ErrorModel(
                    fault: ErrorRespose(
                        faultstring: "Unknown error",
                        detail: Detail(errorcode: error.localizedDescription)
                    ),
                    progress: nil
                )
                self.responseNewsFeedError.value = unknownError
                self.errorStatusCode.value = -1
            }
        }
    }
    
    
    
    
    
    
}


