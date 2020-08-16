import Foundation

/// The request build class
final class RequestFactory {
    enum Method: String {
        case GET
        case POST
        case PUT
    }
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
