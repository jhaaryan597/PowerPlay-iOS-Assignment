import Foundation

// The Specs object in the API has dynamic keys and mixed value types (String, Bool).
// A dictionary is the most flexible way to decode this. We'll use a custom
// JSONValue enum to handle the different possible types.

typealias Specs = [String: JSONValue]

enum JSONValue: Codable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        throw DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }

    var description: String {
        switch self {
        case .string(let value):
            return value
        case .bool(let value):
            return String(value)
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        }
    }
}
