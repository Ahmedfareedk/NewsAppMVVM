//
//  UserDefaultsManager.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation


enum UserDefaultsKey: String {
    case UserFavorite = "favorite"
    case lastCacheDate = "dateCache"
}

class UserDefaultsManager {
    
    class func saveUserFavorite(_ favorite: UserFavoriteCategoryAndCountry) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorite) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.UserFavorite.rawValue)
        }
    }
    
    class func getUserFavorite() -> UserFavoriteCategoryAndCountry? {
        guard let favoriteData = UserDefaults.standard.object(forKey: UserDefaultsKey.UserFavorite.rawValue) as? Data else { return nil }
        guard let favoriteObject = try? JSONDecoder().decode(UserFavoriteCategoryAndCountry.self, from: favoriteData) else { return nil }
        return favoriteObject
    }
    
    class func saveLastCacheDate(date: Date = Date()) {
        UserDefaults.standard.set(date, forKey: UserDefaultsKey.lastCacheDate.rawValue)
    }
    
    class func getLastCacheDate() -> Date? {
        UserDefaults.standard.object(forKey: UserDefaultsKey.lastCacheDate.rawValue) as? Date
    }
}
