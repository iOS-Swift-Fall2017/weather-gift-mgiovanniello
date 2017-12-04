//
//  TimeInterval+format.swift
//  WeatherGift
//
//  Created by Matt Giovanniello on 12/3/17.
//  Copyright © 2017 Matt Giovanniello. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func format(timeZone: String, dateFormatter: DateFormatter) -> String {
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
    
}
