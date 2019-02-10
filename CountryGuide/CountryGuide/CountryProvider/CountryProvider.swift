//
//  CountryProvider.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 09/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

struct CountrySummaryInfo {
    
    private let info: CountryInfo
    
    let borders: [Country]
    
    var countryName: String {
        return info.name
    }
    
    var capital: String {
        return info.capital
    }
    
    var population: String {
        return String(info.population)
    }
    
    var currencies: [Currency] {
        return info.currencies
    }
    
    // MARK: - init
    
    init(info: CountryInfo, borders: [Country]) {
        self.info = info
        self.borders = borders
    }
}

protocol ICountryProvider {

    func getCountries(completion: @escaping ResultBlock<[Country]>)
    
    func getSummaryInfo(of country: Country, completion: @escaping ResultBlock<CountrySummaryInfo>)
    
    func findContries(byCodes codes: [String]) -> [Country]
}

final class CountryProvider: ICountryProvider {
    
    private let apiService: APIService
    private var countries: [Country] = []
    
    // MARK: - init
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getCountries(completion: @escaping ResultBlock<[Country]>) {
        
        apiService.getAllCountires { [weak self] result in
            guard let this = self else { return }
            
            switch result {
            case .success(let allCountries):
                this.countries = allCountries
                completion(result)
            case .failure(_):
                completion(result)
            }
        }
    }
    
    func getSummaryInfo(of country: Country, completion: @escaping ResultBlock<CountrySummaryInfo>) {
        
        apiService.getDetails(of: country) { [weak self] result in
            
            guard let this = self else { return }
            
            switch result {
            case .success(let info):
            
                let borders = this.findContries(byCodes: info.borders)
                let summary = CountrySummaryInfo(info: info, borders: borders)
                completion(.success(summary))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func findContries(byCodes codes: [String]) -> [Country] {
        return countries.filter { codes.contains($0.alpha3Code) }
    }
}
