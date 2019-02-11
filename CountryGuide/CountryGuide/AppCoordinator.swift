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

final class AppCoordinator {
    
    private let countryProvider: ICountryProvider
    private let window: UIWindow
    private var rootNavigationController: UINavigationController!
    private let reachability = Reachability()
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
        countryProvider = CountryProvider(apiService: APIService())
    }
    
    func start() {        
        
        let viewModel = CountryListViewModel(countryProvider: countryProvider)
        let viewController = CountryListViewController.newInstance(viewModel: viewModel)
        viewController.delegate = self
        rootNavigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        try? reachability?.startNotifier()
    }
    
    private func showDetails(of selectedCountry: Country) {
        
        let viewModel = CountryDetailsViewModel(country: selectedCountry, countryProvider: countryProvider)
        let viewController = CountryDetailsViewController.newInstance(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: CountryListDelegate {
    
    func didSelectCountry(_ selectedCountry: Country) {
        showDetails(of: selectedCountry)
    }
}
