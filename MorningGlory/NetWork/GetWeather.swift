//
//  GetWeather.swift
//  MorningGlory
//
//  Created by 최대성 on 9/14/24.
//

import Foundation
import Alamofire

final class GetWeather {
    
    static let shared = GetWeather()
    
    private init() {}
    
    func callWeather(lat: Double, lon: Double, completionHandler: @escaping (Weather) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?"
        let param: Parameters = [
            "APIKey" : APIKey.key,
            "lat" : "\(lat)",
            "lon" : "\(lon)",
            "units" : "metric",
            "lang" : "kr"
        ]
        AF.request(url, parameters: param).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
