//
//  RandomFamousSaying.swift
//  MorningGlory
//
//  Created by 최대성 on 9/13/24.
//

import Foundation
import Alamofire

struct GetSaying: Decodable {
    let message: String
}

final class RandomFamousSaying {
    
    func getSaying(completionHandler: @escaping (Result<GetSaying, Error>) -> Void) {
        
        let url = "https://korean-advice-open-api.vercel.app/api/advice"
        
        AF.request(url)
            .responseDecodable(of: GetSaying.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
