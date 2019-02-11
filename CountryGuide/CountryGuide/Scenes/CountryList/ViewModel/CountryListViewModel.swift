//
//  CountryListViewModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class CountryListViewModel: StateViewModel {
    
    private let countryProvider: ICountryProvider
    private (set) var countries = BehaviorRelay<[Country]>(value: [])
    
    // MARK: - init
    
    init(countryProvider: ICountryProvider) {
        self.countryProvider = countryProvider
        super.init()
        title.accept("Countries")
    }
    
    override func preloadDataIfRequired() {
        guard countries.value.isEmpty else { return }
        loadCountries()
    }
    
    func refreshData() {
        loadCountries(animateLoading: countries.value.isEmpty)
    }
    
    private func loadCountries(animateLoading: Bool = true) {
        
        guard !state.value.isLoading else { return }
        
        if animateLoading {
            state.accept(.loading)
        }
        
        countryProvider.getCountries { [weak self] result in            
            guard let this = self else { return }
            
            switch result {
            case .success(let countries):
                this.countries.accept(countries)
                this.state.accept(.ready)
            case .failure(let error):
                this.state.accept(.error(lastError: error))
            }
        }
    }
}
