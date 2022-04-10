//
//  Date+Extension.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import Foundation

extension Date {
    func calculateDifferenceInMinutes() -> Int {
        let currentDate = Date()
        let component: Set<Calendar.Component> = [.minute]
        let difference = Calendar.current.dateComponents(component, from: self, to: currentDate)
        return difference.minute ?? 0
    }
}
