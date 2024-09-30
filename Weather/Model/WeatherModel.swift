//
//  WeatherModel.swift
//  Weather
//
//  Created by Daris Mathew on 03.09.24.
//

import Foundation

struct WeatherModel: Equatable {
    var locationName: String
    var weatherName: String
    var description: String
    var temperature: Double
    var feelsLikeTemperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var icon: String
    var windSpeed: Double
    var humidity: Double
    var clouds: Double
    var pressure: Double
    var visibility: Double
    var sunrise: Double
    var sunset: Double
    var windGust: Double
    var country: String
    var precipitation: String
    
    init(from data: WeatherRawData) {
        self.locationName = data.name
        self.temperature = data.main.temp
        self.feelsLikeTemperature = data.main.feels_like
        self.minTemperature = data.main.temp_min
        self.maxTemperature = data.main.temp_max
        self.windSpeed = data.wind.speed
        self.humidity = data.main.humidity
        self.clouds = data.clouds.all
        self.pressure = data.main.pressure
        self.visibility = data.visibility ?? 0.0
        self.sunrise = data.sys?.sunrise ?? 0.0
        self.sunset = data.sys?.sunset ?? 0.0
        self.country = data.sys?.country ?? "N/A"
        self.windGust = data.wind.gust ?? 0.0

        guard let weatherData = data.weather.first else {
            self.weatherName = "N/A"
            self.description = "No description available"
            self.icon = ""
            self.precipitation = "No Precipitation"
            return
        }

        self.weatherName = weatherData.main
        self.description = weatherData.description
        self.icon = weatherData.icon

        if let rainVolume = data.rain?.oneHour {
            self.precipitation = "\(rainVolume) mm/h (Rain)"
        } else if let snowVolume = data.snow?.oneHour {
            self.precipitation = "\(snowVolume) mm/h (Snow)"
        } else {
            self.precipitation = "No Precipitation"
        }
    }
}


// Raw Data Model Directly Mapped to API Response
struct WeatherRawData: Codable {
    var name: String
    var timezone: Double
    var weather: [WeatherData]
    var main: MainData
    var wind: WindData
    var clouds: CloudsData
    var visibility: Double?
    var rain: PrecipitationData?
    var snow: PrecipitationData?
    var sys: SysData?
    
    struct WeatherData: Codable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainData: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindData: Codable {
        var speed: Double
        var deg: Double
        var gust: Double?
    }
    
    struct CloudsData: Codable {
        var all: Double
    }
    
    struct PrecipitationData: Codable {
        var oneHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
    
    struct SysData: Codable {
        var country: String?
        var sunrise: Double?
        var sunset: Double?
    }
}
