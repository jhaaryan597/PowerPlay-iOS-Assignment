import Foundation

struct Config {
    static func string(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict[key] as? String else {
            fatalError("Could not find key '\(key)' in 'Configuration.plist'")
        }
        return value
    }
}
