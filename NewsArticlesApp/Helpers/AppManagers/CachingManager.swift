//
//  CachingManager.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import Foundation

class CachingManager {
    
    static let shared = CachingManager()
    
    private let itemArchiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent("articles.plist")
    }()
    
    private init() {}
    
    @discardableResult
    func saveArticles(_ articles: [Article]) -> Bool {
        var isSaved = false
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(articles)
            try data.write(to: itemArchiveURL, options: [.atomic])
            UserDefaultsManager.saveLastCacheDate()
            isSaved = true
        } catch (let encodingError) {
            print(encodingError.localizedDescription)
        }
        return isSaved
    }
    
    
    func loadArticles() -> [Article] {
        var articles = [Article]()
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            articles = try unarchiver.decode([Article].self, from: data)
        } catch (let decodingError) {
            debugPrint("Error reading in saved articles: \(decodingError)")
        }
        return articles
    }
}
