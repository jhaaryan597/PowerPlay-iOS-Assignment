import Foundation

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
}
