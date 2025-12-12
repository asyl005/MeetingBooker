import Foundation
import SwiftUI
import Combine


class Database {
    static let shared = Database()
    private init() {}
    
    func save<T: Codable>(_ value: T?, key: String) {
        guard let value = value else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(T.self, from: data)
    }
}

