//
//  CountryDetailsCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 13/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class CountryDetailsCoordinator: BaseCoordinator {
    
    private let countryProvider: ICountryProvider
    private let selectedCountry: Country
    
    // MARK: - init
    
    init(navigationController: UINavigationController,
         countryProvider: ICountryProvider,
         selectedCountry: Country) {
        
        self.countryProvider = countryProvider
        self.selectedCountry = selectedCountry
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        
        let viewModel = CountryDetailsViewModel(country: selectedCountry, countryProvider: countryProvider)
        pushViewController(ofType: CountryDetailsViewController.self,
                           storyboardId: "country-details",
                           viewModel: viewModel)
    }
}
