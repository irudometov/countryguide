//
//  RestCountriesService.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

enum RestCountriesService {
    case all
    case name(countryName: String)
}

extension RestCountriesService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://restcountries.eu/rest/v2")!
    }
    
    var path: String {
        switch self {
        case .all:
            return "all"
        case .name(let countryName):
            return "name/\(countryName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .all, .name(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .all, .name(_):
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    
}

// MARK: - Helpers

private extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
