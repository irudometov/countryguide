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
import Reachability
import RxReachability
import RxSwift

final class CountryDetailsViewModel {
    
    private let countryProvider: ICountryProvider
    private let country: Country
    private var countrySummary = BehaviorRelay<CountrySummaryInfo?>(value: nil)
    
    private var isReachable: Observable<Bool>?
    private let disposeBag = DisposeBag()
    
    private var summary: CountrySummaryInfo? {
        didSet {
            title.accept(summary?.countryName ?? "Details")
            countrySummary.accept(summary)
        }
    }
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    let title: BehaviorRelay<String>
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
        title = BehaviorRelay<String>(value: country.name)
    }
    
    func onViewWillAppear() {
        preloadCountryInfo()
        startTrackingReachability()
    }
    
    func onViewWillDisppear() {
        stopTrackingReachability()
    }
    
    private func preloadCountryInfo() {
        
        isLoading.accept(true)
        
        countryProvider.getSummaryInfo(of: country) { [weak self] result in
            
            guard let this = self else { return }
            this.isLoading.accept(false)
            
            switch result {
            case .success(let summary):
                this.summary = summary
            case .failure(let error):
                print("fail to load countries: \(error.localizedDescription)")
            }
        }
    }
    
    private static func buildCellModels(for summary: CountrySummaryInfo) -> [CountryPropertyCellModel] {
        
        var models = [CountryPropertyCellModel]()
        
        // Basic info
        
        models.append(.basicInfo(summary: summary))
        
        // Currencies
        
        if !summary.currencies.isEmpty {
            
            models.append(.sectionTitle(text: "Currencies".uppercased()))
            models.append(contentsOf: summary.currencies.map {
                let model = CurrencyCellModel(currencyName: $0.name, currencySymbol: $0.symbol ?? "-")
                return .currency(model: model)
            })
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

private extension CountryDetailsViewModel {
    
    // MARK: - Reachability
    
    func startTrackingReachability() {
        
        guard isReachable == nil else { return }
        
        isReachable =  Reachability.rx.isReachable.asObservable()
        isReachable?.bind(onNext: { [weak self] hasConnection in
            guard let this = self else { return }
            
            if this.countrySummary.value == nil {
                this.preloadCountryInfo()
            }
        }).disposed(by: disposeBag)
    }
    
    func stopTrackingReachability() {
        isReachable = nil
    }
}
