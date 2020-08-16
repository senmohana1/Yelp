import Foundation

final class RequestService {
    static let shared = RequestService()
    static let API_URL = "https://api.yelp.com/v3/businesses/search?location=%@&limit=50"
    static let API_Key = "OKT42_lgUc9PdxhmEu0K13WudgCzRf4FP_3ZARbJQEkwc4pS3ZV9h1BgJXw-UE8s5e5uGSod53_0ZoD8GAacWJGk1yiim85ZqtjxheoKvRMUMtOfiiRPmP5jaDPKXHYx"
    
    /// API call to get beusiness details
    func getBusinessDetails (location: String, completionHandler: @escaping(Result<(URLResponse,Data),Error>) -> Void) {
        guard let url = URL(string: String(format: RequestService.API_URL, location).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        var request = RequestFactory.request(method: .GET, url: url)
        request.addValue("Bearer " + RequestService.API_Key, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { result in
            completionHandler(result)
        }
        task.resume()
    }
}

extension URLSession {
    func dataTask(with urlRequest: URLRequest , result: @escaping(Result<(URLResponse,Data),Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) {data,reponse,error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let reponse = reponse , let data = data else{
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((reponse,data)))
        }
    }
}
