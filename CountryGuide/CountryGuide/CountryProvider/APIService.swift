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

typealias ResultBlock<T> = (Result<T>) -> Void

// Data model

struct Country: Decodable {
    
    let name: String
    let alpha3Code: String
    let population: Int
    let flag: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, alpha3Code, population, flag
    }
}

/*
{
    "code": "RUB",
    "name": "Russian ruble",
    "symbol": "₽"
}
*/
struct Currency: Decodable {
    
    let code: String
    let name: String
    let symbol: String?
    
    private enum CodingKeys: String, CodingKey {
        case code, name, symbol
    }
}

struct CountryInfo: Decodable {
    
    let name: String
    let alpha3Code: String
    let population: Int
    let capital: String
    let flag: String?
    let borders: [String]
    let currencies: [Currency]

    private enum CodingKeys: String, CodingKey {
        case name, alpha3Code, population, flag
        case capital, borders, currencies
    }
}

// API Service

final class APIService: MoyaProvider<RestCountriesService> {
    
    private static func parseJSONResponse<T: Decodable>(_ response: Moya.Response,
                                                        type: T.Type = T.self,
                                                        log: Bool = false,
                                                        _ completion: @escaping ResultBlock<T>) {
       
        do {
            let _ = try response.filterSuccessfulStatusCodes()
            
            if log, let string = String(data: response.data, encoding: .utf8) {
                print("parse response: \(string)")
            }
            
            let model = try JSONDecoder().decode(T.self, from: response.data)
            completion(Result.success(model))
        }
        catch {
            completion(Result.failure(error))
        }
    }
    
    func getAllCountires(completion: @escaping ResultBlock<[Country]>) {
        
        request(.all) { result in
            switch result {
            case .success(let response):
                APIService.parseJSONResponse(response, completion)
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func getDetails(of country: Country, completion: @escaping ResultBlock<CountryInfo>) {
        
        request(.name(countryName: country.name)) { result in
            switch result {
            case .success(let response):
                APIService.parseJSONResponse(response, type: [CountryInfo].self, log: true) { result in
                    
                    switch result {
                    case .success(let countryInfoList):
                        if let first = countryInfoList.first {
                            completion(.success(first))
                        } else {
                            let error = NSError(domain: "com.CountryGuide.error.APIService.parseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail to parse county details reponse."])
                            completion(Result.failure(error))
                        }
                    case .failure(let error):
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
