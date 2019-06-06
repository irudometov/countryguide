//
//  IErrorViewContainer.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 11/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import UIKit

protocol IErrorView {
    
    typealias RetryBlock = () -> Void
    
    var text: String? { get set }
    var onRetry: RetryBlock? { get set }
}

protocol IErrorViewContainer: AnyObject {
    
    associatedtype ViewType: UIView & IErrorView
    
    var errorView: ViewType? { get set }
    
    func displayError(_ error: Error?, onRetry: IErrorView.RetryBlock?)
    func hideErrorView()
}

extension IErrorViewContainer where Self : UIViewController {
    
    private var defaultHorizontalSpace: CGFloat {
        return CGFloat(16)
    }
    
    func displayError(_ error: Error?, onRetry: IErrorView.RetryBlock?) {
        
        guard var errorView = self.errorView ?? ViewType.loadFromNib() else { return }
        
        errorView.text = error?.localizedDescription ?? "Unknown error has occured"
        errorView.onRetry = onRetry
        
        view.addSubview(errorView)
        
        // Setup constraints
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorView.widthAnchor.constraint(equalToConstant: max(0, view.bounds.width - defaultHorizontalSpace * 2)).isActive = true
        view.bringSubviewToFront(errorView)
        
        self.errorView = errorView
    }
    
    func hideErrorView() {
        guard let errorView = self.errorView else { return }
        errorView.removeFromSuperview()
        self.errorView = nil
    }
}
