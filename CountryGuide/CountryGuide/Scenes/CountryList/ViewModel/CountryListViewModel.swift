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

final class CountryListViewModel {
    
    private let countryProvider: ICountryProvider
    
    let state = BehaviorRelay<ViewModelState>(value: .initial)
    let title = BehaviorRelay<String>(value: "Countries")
    private (set) var countries = BehaviorRelay<[Country]>(value: [])
    
    // MARK: - init
    
    init(countryProvider: ICountryProvider) {
        self.countryProvider = countryProvider
    }
    
    func onViewWillAppear() {
        guard countries.value.isEmpty else { return }
        loadCountries()
    }
    
    func refreshData(completion: ResultBlock<Bool>? = nil) {
        loadCountries(animateLoading: countries.value.isEmpty, completion: completion)
    }
    
    private func loadCountries(animateLoading: Bool = true, completion: ResultBlock<Bool>? = nil) {
        
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
                completion?(.success(true))
            case .failure(let error):
                this.state.accept(.error(lastError: error))
                completion?(.failure(error))
            }
        }
    }
    
    private func testError() -> Error {
        return NSError(domain: "com.irudometov.CountryGuide.error",
                       code: 1,
                       userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}
