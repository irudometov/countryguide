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
    
    private let apiService: APIService
    
    let title = BehaviorRelay<String>(value: "Countries")
    private (set) var countries = BehaviorRelay<[Country]>(value: [])
    
    // MARK: - init
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func onViewWillAppear() {
        loadCountries()
    }
    
    func loadCountries() {
        
        apiService.loadCountires { [weak self] result in            
            guard let this = self else { return }
            
            switch result {
            case .success(let countries):
                this.countries.accept(countries)
            case .failure(let error):
                print("fail to load countries: \(error.localizedDescription)")
            }
        }
    }
}
