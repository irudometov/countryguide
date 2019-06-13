//
//  ICoordinator.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 13/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

protocol ICoordinator {
    
    var uuid: UUID { get }
    
    var childCoordinators: [ICoordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}

protocol Coordinated where Self: UIViewController {
    
    var coordinator: ICoordinator? { get set }
}
