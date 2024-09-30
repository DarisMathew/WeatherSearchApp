//
//  WeatherServiceProtocol.swift
//  Weather
//
//  Created by Daris Mathew on 03.09.24.
//

import Foundation

protocol WeatherServiceProtocol {
     func getCurrentWeather(location: String) async throws -> WeatherRawData
}
