import Foundation

class APIService: NetworkServiceProtocol {
    
    private let baseURL = "https://fakeapi.net/products"
    
    func fetchProducts(page: Int, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "category", value: "electronics")
        ]
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
