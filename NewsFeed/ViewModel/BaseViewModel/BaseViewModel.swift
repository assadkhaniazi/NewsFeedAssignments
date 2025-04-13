import Foundation

class BaseViewModel: NSObject {
    
    let networkManager: NetworkManager = NetworkManager()
    var completeResponse: Box<Int?> = Box(nil)
    
    // Variables to store status codes
    var errorStatusCode: Box<Int?> = Box(nil)
    
    var urlErrorObserver: Box<URLError?> = Box(nil)
    
    internal func handleError(
        data: ApiError<ErrorModel>?,
        errorObserver: Box<ErrorModel?>,
        expireObserver: Box<ErrorModel?>,
        statusCodeObserver: Box<Int?>
    ) {
        guard let data = data else { return }

        var updatedError = extractError(from: data)

        switch data {
        case .forbidden(_, let statusCode):
            dump("Forbidden error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "You don't have permission to do this action."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .badRequest(_, let statusCode):
            dump("Bad request error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "Invalid request. Please check your inputs."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .apiKeyIncorrect(_, let statusCode):
            dump("API Key error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "Authentication failed. Please log in again."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode
            expireObserver.value = updatedError

        case .notFound(_, let statusCode):
            dump("Not found error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "The requested resource was not found."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .notAllowed(_, let statusCode):
            dump("Not allowed error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "This action is not allowed."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .unProcessEntity(_, let statusCode):
            dump("Unprocessable entity error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "Something went wrong. Please try again."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .paymentIssue(_, let statusCode):
            dump("Payment issue error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "There was a problem with your payment."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

        case .noInternet(_, let statusCode):
            dump("No Internet \(String(describing: statusCode))")
            statusCodeObserver.value = statusCode
            
            
        case .defaultError(_, let statusCode):
            dump("Default error with status code: \(String(describing: statusCode))")
            updatedError.fault?.faultstring = "An unexpected error occurred."
            errorObserver.value = updatedError
            statusCodeObserver.value = statusCode

       

        default:
            break
        }
    }


    private func extractError(from apiError: ApiError<ErrorModel>) -> ErrorModel {
        switch apiError {
        case .forbidden(let error, _),
             .badRequest(let error, _),
             .apiKeyIncorrect(let error, _),
             .notFound(let error, _),
             .notAllowed(let error, _),
             .unProcessEntity(let error, _),
             .paymentIssue(let error, _),
             .noInternet(let error, _),
             .defaultError(let error, _):
                
            return error

        default:
            return ErrorModel(fault: ErrorRespose(faultstring: "Something went wrong", detail: nil), progress: nil)
        }
    }

    
    
}
