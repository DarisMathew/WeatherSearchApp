//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Daris Mathew on 03.09.24.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    private let weatherService: WeatherServiceProtocol
    @Published var weatherModel: WeatherModel?
    @Published private(set) var isLoading = false
    @Published var isError = false
    
    init(service: WeatherServiceProtocol) {
        weatherService = service
    }
    
    var isDaytime: Bool {
        guard let weatherModel = weatherModel else { return true }
        let currentTime = Date().timeIntervalSince1970
        return currentTime >= weatherModel.sunrise && currentTime < weatherModel.sunset
    }
    
    var weatherMain: String {
        weatherModel?.weatherName ?? "Unknown"
    }
    
    var location: String {
        weatherModel?.locationName ?? "Unknown Location"
    }
    
    var weatherCondition: String {
        weatherModel?.weatherName ?? "N/A"
    }
    
    var description: String {
        weatherModel?.description ?? "No description"
    }
    
    var temperature: String {
        guard let temp = weatherModel?.temperature else { return "-- °C" }
        return String(format: "%.1f°C", temp)
    }
    
    var feelsLikeTemperature: String {
        guard let temp = weatherModel?.feelsLikeTemperature else { return "-- °C" }
        return String(format: "%.1f°C", temp)
    }
    
    var minTemperature: String {
        guard let temp = weatherModel?.minTemperature else { return "-- °C" }
        return String(format: "%.1f°C", temp)
    }
    
    var maxTemperature: String {
        guard let temp = weatherModel?.maxTemperature else { return "-- °C" }
        return String(format: "%.1f°C", temp)
    }
    
    var humidity: String {
        "\(weatherModel?.humidity ?? 0)%"
    }
    
    var pressure: String {
        "\(weatherModel?.pressure ?? 0) hPa"
    }
    
    var cloudiness: String {
        "\(weatherModel?.clouds ?? 0)%"
    }
    
    var visibility: String {
        guard let visibility = weatherModel?.visibility else { return "-- km" }
        return String(format: "%.1f km", visibility / 1000.0)
    }
    
    var windSpeed: String {
        guard let speed = weatherModel?.windSpeed else { return "-- m/s" }
        return "\(speed) m/s"
    }
    
    var windGust: String {
        guard let gust = weatherModel?.windGust else { return "-- m/s" }
        return "\(gust) m/s"
    }
    
    var precipitation: String {
        weatherModel?.precipitation ?? "No Precipitation"
    }
    
    var sunriseTime: String {
        formatUnixTime(weatherModel?.sunrise ?? 0)
    }
    
    var sunsetTime: String {
        formatUnixTime(weatherModel?.sunset ?? 0)
    }
    
    var iconURLString: String {
        guard let iconCode = weatherModel?.icon else {
            return ""
        }
        return "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
    }
    
    private func formatUnixTime(_ unixTime: Double) -> String {
        guard unixTime > 0 else { return "--" }
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func fetchWeather(forLocation location: String) async {
        isError = false
        isLoading = true
        defer { isLoading = false }
        do {
            let weatherRawData = try await self.weatherService.getCurrentWeather(location: location)
            weatherModel = WeatherModel(from: weatherRawData)
        } catch {
            print("Weather fetching failed. Error: \(error)")
            isError = true
        }
    }
}

