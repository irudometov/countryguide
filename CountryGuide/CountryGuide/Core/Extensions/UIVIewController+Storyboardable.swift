//
//  UIVIewController+Storyboardable.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 14/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

protocol Storyboardable {
    
    static func instantiate(withId identifier: String) -> Self
    static func instantiate(withId identifier: String, storyboardName: String) -> Self
}

extension Storyboardable where Self: UIViewController {
    
    static func instantiate(withId identifier: String) -> Self {
        return instantiate(withId: identifier, storyboardName: "Main")
    }
    
    static func instantiate(withId identifier: String, storyboardName: String) -> Self {
        
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Fail to instantiate a view controller with id '\(identifier)' from storyboard '\(String(describing: storyboardName))'.")
        }
        
        return viewController
    }
}
