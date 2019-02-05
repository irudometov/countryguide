//
//  AppCoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

final class AppCoordinator {
    
    private let apiService = APIService()
    private let window: UIWindow
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {        
        let viewModel = CountryListViewModel(apiService: APIService())
        let countryList = CountryListViewController.newInstance(viewModel: viewModel)
        window.rootViewController = UINavigationController(rootViewController: countryList)
        window.makeKeyAndVisible()
    }
}
