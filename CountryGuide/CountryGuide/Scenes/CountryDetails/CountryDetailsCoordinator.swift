//
//  CountryDetailsCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 13/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class CountryDetailsCoordinator: ICoordinator {
    
    let uuid: UUID = UUID()
    
    var childCoordinators: [ICoordinator] = []
    let navigationController: UINavigationController
    
    private let countryProvider: ICountryProvider
    private let selectedCountry: Country
    
    // MARK: - init
    
    init(navigationController: UINavigationController,
         countryProvider: ICountryProvider,
         selectedCountry: Country) {
        
        self.navigationController = navigationController
        self.countryProvider = countryProvider
        self.selectedCountry = selectedCountry
    }
    
    func start() {
        let viewModel = CountryDetailsViewModel(country: selectedCountry, countryProvider: countryProvider)
        let viewController = CountryDetailsViewController.newInstance(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
