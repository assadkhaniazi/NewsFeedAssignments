import Foundation


open class BaseApiClient {
    
    static func request<T: Decodable, E: Codable>(
        urlRequest: URLRequest,
        errorType: E.Type
    ) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError<E>.unknownError
            }

            let statusCode = httpResponse.statusCode
            let decoder = JSONDecoder()

            switch statusCode {
            case 200...299:
                return try decoder.decode(T.self, from: data)

            case 400...499:
                let error = try? decoder.decode(errorType, from: data)
                let parsedError = error ?? Self.defaultEmptyError()
                switch statusCode {
                case 400:
                    throw ApiError.badRequest(error: parsedError, statusCode: statusCode)
                case 401:
                    throw ApiError.apiKeyIncorrect(error: parsedError, statusCode: statusCode)
                case 402:
                    throw ApiError.paymentIssue(error: parsedError, statusCode: statusCode)
                case 403:
                    throw ApiError.forbidden(error: parsedError, statusCode: statusCode)
                case 404:
                    throw ApiError.notFound(error: parsedError, statusCode: statusCode)
                case 405:
                    throw ApiError.notAllowed(error: parsedError, statusCode: statusCode)
                case 422:
                    throw ApiError.unProcessEntity(error: parsedError, statusCode: statusCode)
                default:
                    throw ApiError.defaultError(error: parsedError, statusCode: statusCode)
                }

            case 500...599:
                let error = try? decoder.decode(errorType, from: data)
                throw ApiError.internalServerError(error: error ?? Self.defaultEmptyError(), statusCode: statusCode)

            default:
                throw ApiError<E>.unknownError
            }

        } catch {
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet {
                    throw ApiError<E>.noInternet(error: Self.defaultEmptyError(), statusCode: 404)
                } else {
                    throw ApiError<E>.urlError(urlError, urlError.errorCode)
                }
            } else if let apiError = error as? ApiError<E> {
                throw apiError
            } else {
                throw ApiError<E>.unknownError
            }
        }
    }

    
    private static func defaultEmptyError<E: Decodable>(message: String = "Unknown error") -> E {
        let emptyJSON = "{}".data(using: .utf8)!
        if let empty = try? JSONDecoder().decode(E.self, from: emptyJSON) {
            return empty
        }
        return GenericError(message: message) as! E
    }
}

