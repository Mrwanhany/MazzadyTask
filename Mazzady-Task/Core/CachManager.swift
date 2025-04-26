//
//  CachManager.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    private init() {}
    
    private func cacheDirectory() -> URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    func save<T: Codable>(_ object: T, to filename: String) {
        guard let url = cacheDirectory()?.appendingPathComponent(filename) else { return }
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
            print("✅ Saved to cache: \(filename)")
        } catch {
            print("❌ Error saving to cache: \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, from filename: String) -> T? {
        guard let url = cacheDirectory()?.appendingPathComponent(filename) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            print("✅ Loaded from cache: \(filename)")
            return decodedObject
        } catch {
            print("❌ Error loading from cache: \(error)")
            return nil
        }
    }
}
