//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Matt Giovanniello on 12/3/17.
//  Copyright © 2017 Matt Giovanniello. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var coordinates: String
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
    
}
