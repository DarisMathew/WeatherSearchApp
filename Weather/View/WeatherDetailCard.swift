//
//  WeatherDetailCard.swift
//  Weather
//
//  Created by Daris Mathew on 28.09.24.
//

import SwiftUI

struct WeatherDetailCard: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                headerView
                temperatureSection
                weatherAttributesSection
                windSection
                sunInformationSection
                precipitationSection
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
        )
        .padding(.horizontal, 16)
    }
    
    private var headerView: some View {
        VStack {
            Text(weatherViewModel.location)
                .font(.largeTitle).bold()
                .foregroundColor(.white)
            HStack {
                AsyncImage(url: URL(string: weatherViewModel.iconURLString)) { image in
                    image
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
                .shadow(radius: 5)
                .padding()
                VStack(alignment: .leading) {
                    Text(weatherViewModel.weatherCondition)
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    Text(weatherViewModel.description.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    @ViewBuilder
    private var temperatureSection: some View {
        sectionView(title: "Temperature Details") {
            WeatherDetailRow(label: "Current Temp", value: weatherViewModel.temperature)
            WeatherDetailRow(label: "Feels Like", value: weatherViewModel.feelsLikeTemperature)
            WeatherDetailRow(label: "Min Temp", value: weatherViewModel.minTemperature)
            WeatherDetailRow(label: "Max Temp", value: weatherViewModel.maxTemperature)
        }
    }
    
    @ViewBuilder
    private var weatherAttributesSection: some View {
        sectionView(title: "Weather Attributes") {
            WeatherDetailRow(label: "Pressure", value: weatherViewModel.pressure)
            WeatherDetailRow(label: "Humidity", value: weatherViewModel.humidity)
            WeatherDetailRow(label: "Cloudiness", value: weatherViewModel.cloudiness)
            WeatherDetailRow(label: "Visibility", value: weatherViewModel.visibility)
        }
    }
    
    @ViewBuilder
    private var windSection: some View {
        sectionView(title: "Wind Information") {
            WeatherDetailRow(label: "Wind Speed", value: weatherViewModel.windSpeed)
            WeatherDetailRow(label: "Wind Gust", value: weatherViewModel.windGust)
        }
    }
    
    @ViewBuilder
    private var sunInformationSection: some View {
        sectionView(title: "Sun Information") {
            WeatherDetailRow(label: "Sunrise", value: weatherViewModel.sunriseTime)
            WeatherDetailRow(label: "Sunset", value: weatherViewModel.sunsetTime)
        }
    }
    
    private var precipitationSection: some View {
        sectionView(title: "Precipitation") {
            Text(weatherViewModel.precipitation)
                .font(.title3).bold()
                .foregroundColor(.white)
        }
    }
    
    private func sectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            content()
            Divider().background(Color.white)
        }
        .padding(.vertical, 5)
    }
}

struct WeatherDetailRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label + " :")
                .bold()
                .frame(width: 130, alignment: .leading)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding(.vertical, 2)
    }
}
