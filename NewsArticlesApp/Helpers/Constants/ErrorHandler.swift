//
//  ErrorHandler.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation


enum ErrorHandler: Error {
    case generalError
    case selectDropDown
    case invalidURL
    case custom(String)
    
    var message: String {
        switch self {
        case .generalError:
            return "It is out fault not yours, please try again"
        case .selectDropDown:
            return "Please determine all required fields"
        case .invalidURL:
            return "invalid URL"
        case .custom(let message):
            return message
        }
    }
}
