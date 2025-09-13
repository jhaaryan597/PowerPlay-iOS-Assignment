import Foundation

struct APIResponse: Codable {
    let data: [Product]
    let pagination: Pagination
}
