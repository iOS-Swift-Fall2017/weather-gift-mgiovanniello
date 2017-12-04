//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Matt Giovanniello on 10/24/17.
//  Copyright © 2017 Matt Giovanniello. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherDetail: WeatherLocation {
    
    struct HourlyForecast {
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    

    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    
    var hourlyForecastArray = [HourlyForecast]()
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let temperature = json["currently"]["temperature"].double {
                        let roundedTemp = String(format: "%3.f", temperature)
                        self.currentTemp = roundedTemp + "°"
                    } else {
                        print("Could not return a temperature")
                    }
                    if let summary = json["daily"]["summary"].string {
                        self.currentSummary = summary
                    } else {
                        print("Could not return a summary")
                    }
                    if let icon = json["currently"]["icon"].string {
                        self.currentIcon = icon
                    } else {
                        print("Could not return an icon")
                    }
                    if let timeZone = json["timezone"].string {
                        print("TIMEZONE for \(self.name) is \(timeZone)")
                        self.timeZone = timeZone
                    } else {
                        print("Could not return time zone")
                    }
                    if let time = json["currently"]["time"].double {
                        print("TIME for \(self.name) is \(time)")
                        self.currentTime = time
                    } else {
                        print("Could not return a time")
                    }
                    
                    let dailyDataArray = json["daily"]["data"]
                    self.dailyForecastArray = []
                    for day in 1...min(7, dailyDataArray.count - 1) {
                        let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                        let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                        let dateValue = json["daily"]["data"][day]["time"].doubleValue
                        let icon = json["daily"]["data"][day]["icon"].string
                        let dailySummary = json["daily"]["data"][day]["summary"].string
                        let newDailyForecast = DailyForecast.init(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary!, dailyDate: dateValue, dailyIcon: icon!)
                        self.dailyForecastArray.append(newDailyForecast)
                    }
                    
                    let hourlyDataArray = json["hourly"]["data"]
                    self.hourlyForecastArray = []
                    for hour in 1...min(24, hourlyDataArray.count - 1) {
                        let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                        let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                        let hourlyPrecipProb = json["hourly"]["data"][hour]["precipProbability"].doubleValue
                        let hourlyIcon = json["hourly"]["data"][hour]["icon"].string
                        let newHourlyForecast = HourlyForecast.init(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon!)
                        self.hourlyForecastArray.append(newHourlyForecast)
                    }                    
                    
                case .failure(let error):
                    print(error)
                }
            completed()
        }
    }
}
