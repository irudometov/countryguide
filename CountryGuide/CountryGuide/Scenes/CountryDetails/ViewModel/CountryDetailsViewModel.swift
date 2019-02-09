//
//  CountryDetailsViewModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 07/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class CountryDetailsViewModel {
    
    private let countryProvider: ICountryProvider
    
    private let country: Country
    private var summary: CountrySummaryInfo? {
        didSet {
            if let info = summary {
                
                title.accept(info.countryName)
                
                capital.accept(info.capital)
                population.accept(String(info.population))
                
                let borderList = info.borders.compactMap { $0.name }.joined(separator: "\n")
                borders.accept(borderList)
                
                let currencyList = info.currencies.compactMap { $0.symbol ?? $0.code }.joined(separator: ",")
                currencies.accept(currencyList)
            }
        }
    }
    
    let title: BehaviorRelay<String>
    let population = BehaviorRelay<String>(value: "")
    let capital = BehaviorRelay<String>(value: "")
    let borders = BehaviorRelay<String>(value: "")
    let currencies = BehaviorRelay<String>(value: "")
    
    // MARK: - init
    
    init(country: Country, countryProvider: ICountryProvider) {
        self.country = country
        self.countryProvider = countryProvider
        title = BehaviorRelay<String>(value: country.name)
        population.accept(String(country.population))
    }
    
    func onViewWillAppear() {
        preloadCountryInfo()
    }
    
    private func preloadCountryInfo() {
        
         countryProvider.getSummaryInfo(of: country) { [weak self] result in
            guard let this = self else { return }
            
            switch result {
            case .success(let summary):
                this.summary = summary
            case .failure(let error):
                print("fail to load countries: \(error.localizedDescription)")
            }
        }
    }
}
