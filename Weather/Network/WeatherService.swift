//
//  WeatherService.swift
//  Weather
//
//  Created by Daris Mathew on 03.09.24.
//

import Foundation

enum WeatherServiceError: Error {
    case invalidUrl
    case badResponse
}

class WeatherService : WeatherServiceProtocol {
    private let apiKey = "aee9d4df2adaf52155be159b7c546636"
    private let baseUrlString = "https://api.openweathermap.org/data/2.5/weather"
    
    func getCurrentWeather(location: String) async throws -> WeatherRawData {
        // TODO: Step 1: Implement getCurrentWeather(location:) function
        
        var components = URLComponents(string: baseUrlString)
        components?.queryItems = [
            URLQueryItem(name: "q", value: location),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components?.url else {
            throw WeatherServiceError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Here we can check for other kinds of status and throw an error accordingly
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherServiceError.badResponse
        }
        
        return try JSONDecoder().decode(WeatherRawData.self, from: data)
    }
}
