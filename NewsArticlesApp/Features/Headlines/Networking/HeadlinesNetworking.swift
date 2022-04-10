//
//  HeadlinesNetworking.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation
import Alamofire

enum HeadlinesNetworking {
    case fetchArticles(HeadlineArticleParameters)
}

extension HeadlinesNetworking: Requestable {
    var baseURL: String {
        return NetworkConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchArticles:
            return NetworkConstants.topHeadlines
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArticles:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        switch self {
            
        case .fetchArticles(let params):
          return params.toJSON()
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchArticles(_):
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchArticles:
            return URLEncoding.default
        }
    }
}
