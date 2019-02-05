//
//  APIService.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Alamofire
import Moya

struct Country: Decodable {
    
    let name: String
    let alpha3Code: String
    let population: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, alpha3Code, population
    }
}

final class APIService: MoyaProvider<RestCountriesService> {
    
    func loadCountires(completion: @escaping (Result<[Country]>) -> Void) {
        
        request(.all) { result in
            switch result {
            case .success(let response):
                
                do {
                    let _ = try response.filterSuccessfulStatusCodes()
                    let countries = try JSONDecoder().decode([Country].self, from: response.data)
                    completion(Result.success(countries))
                }
                catch {
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
