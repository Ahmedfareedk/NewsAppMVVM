//
//  Requestable.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}
