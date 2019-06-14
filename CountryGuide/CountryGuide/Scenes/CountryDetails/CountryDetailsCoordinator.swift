//
//  CountryDetailsCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 13/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class CountryDetailsCoordinator: BaseCoordinator {
    
    struct InputModel {
        let selectedCountry: Country
    }
    
    struct Dependencies {
        let countryProvider: ICountryProvider
        let navigationController: UINavigationController
    }
    
    private let input: InputModel
    private let dependencies: Dependencies
    
    // MARK: - init
    
    init(_ input: InputModel,
         _ dependencies: Dependencies) {
        
        self.input = input
        self.dependencies = dependencies
        super.init(navigationController: dependencies.navigationController)
    }
    
    override func start() {
        
        let viewModel = CountryDetailsViewModel(country: input.selectedCountry,
                                                countryProvider: dependencies.countryProvider)
        
        pushViewController(ofType: CountryDetailsViewController.self,
                           storyboardId: "country-details",
                           viewModel: viewModel)
    }
}
