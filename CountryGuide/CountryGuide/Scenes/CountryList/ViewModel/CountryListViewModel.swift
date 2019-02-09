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
    
    func refreshData(completion: @escaping ResultBlock<Bool>) {
        loadCountries(completion: completion)
    }
    
    private func loadCountries(completion: ResultBlock<Bool>? = nil) {
        
        countryProvider.getCountries { [weak self] result in
            guard let this = self else { return }
            
            switch result {
            case .success(let countries):
                this.countries.accept(countries)
                completion?(.success(true))
            case .failure(let error):
                print("fail to load countries: \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
    }
}
