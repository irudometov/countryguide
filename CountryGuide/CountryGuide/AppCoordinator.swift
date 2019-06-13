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

final class AppCoordinator: NSObject, ICoordinator {
    
    private let countryProvider: ICountryProvider
    private let window: UIWindow
    private let reachability = Reachability()
    
    let uuid: UUID = UUID()
    
    var childCoordinators: [ICoordinator] = [] {
        didSet {
            print("child: \(childCoordinators)")
        }
    }
    
    let navigationController = UINavigationController()
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
        countryProvider = CountryProvider(apiService: APIService())
    }
    
    func start() {        
        
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
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func childDidFinish(_ coordinator: ICoordinator) {
        guard let index = childCoordinators.firstIndex(where: { coordinator.uuid == $0.uuid }) else { return }
        childCoordinators.remove(at: index)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let coordinatedViewController = fromViewController as? Coordinated,
            let coordinator = coordinatedViewController.coordinator {
            childDidFinish(coordinator)
        }
    }
}
