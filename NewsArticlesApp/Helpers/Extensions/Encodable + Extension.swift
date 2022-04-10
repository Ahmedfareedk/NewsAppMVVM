//
//  Encodable + Extension.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import Foundation


extension Encodable {
    func toJSON() -> [String: Any] {
        let encoder = JSONEncoder()
        return (try? JSONSerialization.jsonObject(with: encoder.encode(self), options: .allowFragments)) as? [String: Any] ?? [:]
    }
}
