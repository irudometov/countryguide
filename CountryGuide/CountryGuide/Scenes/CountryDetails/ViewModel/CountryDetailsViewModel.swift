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
    
    private let country: Country
    private var countryInfo: CountryInfo? {
        didSet {
            if let info = countryInfo {
                capital.accept(info.capital)
            }
        }
    }
    private let apiService: APIService
    
    let title: BehaviorRelay<String>
    let capital = BehaviorRelay<String>(value: "")
    var countryDetails: BehaviorRelay<CountryInfo>!
    
    // MARK: - init
    
    init(country: Country, apiService: APIService) {
        self.country = country
        self.apiService = apiService
        
        title = BehaviorRelay<String>(value: country.name)
    }
    
    func onViewWillAppear() {
        preloadCountryInfo()
    }
    
    private func preloadCountryInfo() {
        
        apiService.getDetails(of: country) { [weak self] result in
            guard let this = self else { return }
            
            switch result {
            case .success(let countryInfo):
                this.countryInfo = countryInfo
            case .failure(let error):
                print("fail to load countries: \(error.localizedDescription)")
            }
        }
    }
}
