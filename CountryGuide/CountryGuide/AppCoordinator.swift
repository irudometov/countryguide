//
//  AppCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import RxReachability
import RxSwift

final class AppCoordinator: NavigatableCoordinator {
    
    private let countryProvider: ICountryProvider
    private let window: UIWindow
    private let reachability = Reachability()
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
        countryProvider = CountryProvider(apiService: APIService())
    }
    
    override func start() {
        
        let viewModel = CountryListViewModel(countryProvider: countryProvider)
        let viewController = CountryListViewController.newInstance(viewModel: viewModel)
        viewController.didSelectCountry = showDetails
        navigationController.viewControllers = [viewController]
        navigationController.delegate = self
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        try? reachability?.startNotifier()
    }
    
    private func showDetails(of selectedCountry: Country) {
        
        let coordinator = CountryDetailsCoordinator(navigationController: navigationController,
                                                    countryProvider: countryProvider,
                                                    selectedCountry: selectedCountry)
        addChildCoordinatorAndStart(coordinator)
    }
}
