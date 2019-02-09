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
                capital.accept(info.capital)
                borders.accept(info.borders)
            }
        }
    }
    
    let title: BehaviorRelay<String>
    let capital = BehaviorRelay<String>(value: "")
    var borders = BehaviorRelay<[Country]>(value: [])
    
    // MARK: - init
    
    init(country: Country, countryProvider: ICountryProvider) {
        self.country = country
        self.countryProvider = countryProvider
        title = BehaviorRelay<String>(value: country.name)
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
