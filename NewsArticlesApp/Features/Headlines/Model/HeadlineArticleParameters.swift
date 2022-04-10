//
//  HeadlineArticleParameters.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation

struct HeadlineArticleParameters: Codable {
    
    let apiKey: String = NetworkConstants.apiKey
    let country: String
    let category: String
    let page: Int
    let query: String?
    let pageSize: Int?
    
    enum CodingKeys: String, CodingKey {
        case apiKey, country, category, page, pageSize
        case query = "q"
    }
    
    internal init(country: String, category: String, page: Int, query: String? = nil, pageSize: Int? = 20) {
        self.country = country
        self.category = category
        self.query = query
        self.pageSize = pageSize
        self.page = page
    }
}
