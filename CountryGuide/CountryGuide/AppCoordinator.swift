//
//  AppCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

final class AppCoordinator: NSObject {
    
    private let apiService = APIService()
    private let window: UIWindow
    private var rootNavigationController: UINavigationController!
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {        
        
        let viewModel = CountryListViewModel(apiService: APIService())
        let viewController = CountryListViewController.newInstance(viewModel: viewModel)
        viewController.delegate = self
        rootNavigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
    
    private func openContryDetails(for country: Country) {
        
        let viewModel = CountryDetailsViewModel(country: country, apiService: apiService)
        let viewController = CountryDetailsViewController.newInstance(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: CountryListDelegate {
    
    func didSelectCountry(_ country: Country) {
        openContryDetails(for: country)
    }
}
