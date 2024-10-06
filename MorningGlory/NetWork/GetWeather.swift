//
//  GetWeather.swift
//  MorningGlory
//
//  Created by 최대성 on 9/14/24.
//

import Foundation

final class GetWeather {
    
    static let shared = GetWeather()
    
    private init() {}

    func getWeather(lat: Double, lon: Double) async throws -> Weather {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?"
        
        var components = URLComponents(string: url)
        
        components?.queryItems = [
        URLQueryItem(name: "APIKey", value: APIKey.key),
        URLQueryItem(name: "lat", value: "\(lat)"),
        URLQueryItem(name: "lon", value: "\(lon)"),
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "lang", value: "kr")
        ]
     
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let decodeData = try JSONDecoder().decode(Weather.self, from: data)
        
        return decodeData
        
    }
}
