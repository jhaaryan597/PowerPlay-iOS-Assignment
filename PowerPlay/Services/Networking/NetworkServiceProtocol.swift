import Foundation

protocol NetworkServiceProtocol {
    func fetchProducts(page: Int, completion: @escaping (Result<APIResponse, Error>) -> Void)
}
