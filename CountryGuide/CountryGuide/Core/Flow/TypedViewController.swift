//
//  TypedViewController.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 14/06/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

class TypedViewController<VM: StateViewModel>: UIViewController, Storyboardable, Coordinated {
    
    private (set) var viewModel: VM!
    var coordinator: Coordinator?
    
    class func newInstance(viewModel: VM, storyboardId: String) -> Self {
        
        let viewController = instantiate(withId: storyboardId)
        viewController.viewModel = viewModel
        return viewController
    }
}
