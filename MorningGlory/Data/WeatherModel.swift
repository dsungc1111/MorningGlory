//
//  Weather.swift
//  MorningGlory
//
//  Created by 최대성 on 9/14/24.
//

import Foundation


struct CloudsInfo: Decodable {
    let all: Int
}

struct WindInfo: Decodable {
    let speed: Double
    let deg: Int
}

struct WeatherInfo: Decodable {
    let temp, feels_like, temp_min, temp_max : Double
    let pressure, humidity: Int
    
}

struct TodayWeather: Decodable {
    let id: Int
    let main, description, icon: String
}
struct Coord: Decodable {
    let lon, lat: Double
}

struct Weather: Decodable {
    let coord: Coord
    let weather : [TodayWeather]
    let base: String
    let main: WeatherInfo
    let visibility: Int
    let wind: WindInfo
    let clouds: CloudsInfo
    let dt: Int
    let name: String
}
