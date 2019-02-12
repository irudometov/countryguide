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
        switch self {
        case .all, .name(_):
            return """
[{"name":"Russian Federation","topLevelDomain":[".ru"],"alpha2Code":"RU","alpha3Code":"RUS","callingCodes":["7"],"capital":"Moscow","altSpellings":["RU","Rossiya","Russian Federation","Российская Федерация","Rossiyskaya Federatsiya"],"region":"Europe","subregion":"Eastern Europe","population":146599183,"latlng":[60.0,100.0],"demonym":"Russian","area":1.7124442E7,"gini":40.1,"timezones":["UTC+03:00","UTC+04:00","UTC+06:00","UTC+07:00","UTC+08:00","UTC+09:00","UTC+10:00","UTC+11:00","UTC+12:00"],"borders":["AZE","BLR","CHN","EST","FIN","GEO","KAZ","PRK","LVA","LTU","MNG","NOR","POL","UKR"],"nativeName":"Россия","numericCode":"643","currencies":[{"code":"RUB","name":"Russian ruble","symbol":"₽"}],"languages":[{"iso639_1":"ru","iso639_2":"rus","name":"Russian","nativeName":"Русский"}],"translations":{"de":"Russland","es":"Rusia","fr":"Russie","ja":"ロシア連邦","it":"Russia","br":"Rússia","pt":"Rússia","nl":"Rusland","hr":"Rusija","fa":"روسیه"},"flag":"https://restcountries.eu/data/rus.svg","regionalBlocs":[{"acronym":"EEU","name":"Eurasian Economic Union","otherAcronyms":["EAEU"],"otherNames":[]}],"cioc":"RUS"}]
""".data(using: .utf8)!
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
}
