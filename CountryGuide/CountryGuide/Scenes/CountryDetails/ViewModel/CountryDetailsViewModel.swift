//
//  CountryDetailsViewModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 07/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

final class CountryDetailsViewModel: StateViewModel {
    
    private let countryProvider: ICountryProvider
    private let country: Country
    private var countrySummary = BehaviorRelay<CountrySummaryInfo?>(value: nil)
    
    private var summary: CountrySummaryInfo? {
        didSet {
            title.accept(summary?.countryName ?? "Details")
            countrySummary.accept(summary)
        }
    }
    
    var sections: Observable<[AnimatableSectionModel<Int, CountryPropertyCellModel>]> {
        return countrySummary.map { summary in
            guard let summary = summary else { return [AnimatableSectionModel(model: 0, items: [])] }
            let models = CountryDetailsViewModel.buildCellModels(for: summary)
            return [AnimatableSectionModel(model: 0, items: models)]
        }
    }
    
    // MARK: - init
    
    init(country: Country, countryProvider: ICountryProvider) {
        self.country = country
        self.countryProvider = countryProvider
        super.init()
        title.accept(country.name)
    }
    
    override func preloadDataIfRequired() {
        guard countrySummary.value == nil else { return }
        loadCountryInfo()
    }
    
    private func loadCountryInfo() {
        
        guard !state.value.isLoading else { return }
        state.accept(.loading)
        
        countryProvider.getSummaryInfo(of: country) { [weak self] result in
            guard let this = self else { return }
            
            switch result {
            case .success(let summary):
                this.summary = summary
                this.state.accept(.ready)
            case .failure(let error):
                this.state.accept(.error(lastError: error))
            }
        }
    }
    
    private static func buildCellModels(for summary: CountrySummaryInfo) -> [CountryPropertyCellModel] {
        
        var models = [CountryPropertyCellModel]()
        
        // Basic info
        
        models.append(.basicInfo(summary: summary))
        
        // Currencies
        
        if !summary.currencies.isEmpty {
            
            let validCurrencies: [CountryPropertyCellModel] = summary.currencies.compactMap {
                
                // Make sure every currency has non-empty name and symbol.
                
                guard let name = $0.name, let symbol = $0.symbol else { return nil }
                
                let model = CurrencyCellModel(currencyName: name, currencySymbol: symbol)
                return .currency(model: model)
            }
            
            if !validCurrencies.isEmpty {
                models.append(.sectionTitle(text: "Currencies".uppercased()))
                models.append(contentsOf: validCurrencies)
            }
        }
        
        // Borders
        
        if !summary.borders.isEmpty {
            
            models.append(.sectionTitle(text: "Neighboring countries".uppercased()))
            models.append(contentsOf: summary.borders.map {
                return .border(country: $0)
            })
        }
        
        return models
    }
}
