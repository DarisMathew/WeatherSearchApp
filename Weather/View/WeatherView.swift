//
//  WeatherView.swift
//  Weather
//
//  Created by Daris Mathew on 03.09.24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherViewModel = WeatherViewModel(service: WeatherService())
    @State private var city: String = ""
    @State private var isSearchCompleted = false  // Track if a search has been completed
    
    var body: some View {
        ZStack {
            gradientBackground
            VStack {
                appTitle
                searchField
                instructionText
                
                if weatherViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .transition(.opacity)
                        .frame(height: 100)
                }  else if isSearchCompleted {
                    weatherDetailView
                }
                Spacer()
            }
            .padding(.top, 40)  // Adjusted top padding for spacing
        }
        .animation(.easeInOut(duration: 0.3), value: weatherViewModel.weatherModel)  // Smoother state change animations
        .alert("Cant find the Weather data for the city: \(city)", isPresented: $weatherViewModel.isError) {
            Button("OK") {}
        }
    }
    
    // MARK: - Background with Adaptive Gradient
    private var gradientBackground: some View {
        let weatherType = weatherViewModel.weatherMain
        let isDaytime = weatherViewModel.isDaytime
        return LinearGradient(
            gradient: Gradient(colors: weatherBackground(for: weatherType, isDaytime: isDaytime)),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func weatherBackground(for type: String, isDaytime: Bool) -> [Color] {
        switch type.lowercased() {
        case "clear":
            return isDaytime
                ? [Color(red: 0.1, green: 0.6, blue: 1.0), Color(red: 0.0, green: 0.3, blue: 0.8)]
                : [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.0, green: 0.0, blue: 0.1)]
        case "clouds":
            return isDaytime
                ? [Color(red: 0.5, green: 0.6, blue: 0.7), Color(red: 0.3, green: 0.4, blue: 0.5)]
                : [Color(red: 0.2, green: 0.2, blue: 0.3), Color(red: 0.1, green: 0.1, blue: 0.2)]
        case "rain":
            return isDaytime
                ? [Color(red: 0.2, green: 0.3, blue: 0.4), Color(red: 0.1, green: 0.2, blue: 0.3)]
                : [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.0, green: 0.0, blue: 0.1)]
        case "snow":
            return isDaytime
                ? [Color(red: 0.8, green: 0.9, blue: 1.0), Color(red: 0.6, green: 0.7, blue: 0.8)]
                : [Color(red: 0.6, green: 0.6, blue: 0.7), Color(red: 0.5, green: 0.5, blue: 0.6)]
        default:
            return [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.3, blue: 0.8)]
        }
    }
    
    // MARK: - App Title
    private var appTitle: some View {
        Text("Weather Now")
            .font(.largeTitle).bold()
            .foregroundColor(.white)
            .padding(.bottom, 20)
    }
    
    // MARK: - Search Field with Modern Design
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            TextField("",
                      text: $city,
                      prompt: Text("Enter city name")
                .foregroundStyle(.white))
            .foregroundColor(.white)
            .padding(10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .tint(.gray)
            .onSubmit {
                Task {
                    await searchForWeather()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
        .padding(.horizontal, 16)
        .shadow(radius: 5)
    }
    
    // MARK: - Instruction Text
    private var instructionText: some View {
        Text("Search for city names to see the weather data")
            .foregroundColor(.white.opacity(0.8))
            .font(.subheadline)
            .padding(.top, 5)
    }
    
    // MARK: - Weather Detail View
    @ViewBuilder
    private var weatherDetailView: some View {
        WeatherDetailCard(weatherViewModel: weatherViewModel)  // Pass the entire ViewModel
            .padding(.top, 20)
            .transition(.opacity)  // Simpler transition for smoother updates
    }
    
    private func searchForWeather() async {
        await weatherViewModel.fetchWeather(forLocation: city)
        isSearchCompleted = weatherViewModel.weatherModel != nil  // Update state based on search result
    }
}
