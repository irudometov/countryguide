//
//  IStateTableView.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 12/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

protocol IStateTableView {
    
    associatedtype ViewModelType: IStateViewModel
    
    var tableView: UITableView! { get }
    var activityIndicator: UIActivityIndicatorView! { get }
    
    var viewModel: ViewModelType! { get }
    
    func applyState(_ state: ViewModelState)
}

extension IStateTableView where Self : IErrorViewContainer {
    
    func applyState(_ state: ViewModelState) {
        
        tableView.isHidden = !state.isReady
        activityIndicator.animateLoading(state.isLoading)
        
        if !state.isLoading,
            let refreshControl = tableView.refreshControl,
            refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        if case .error(let error) = state {
            displayError(error) { [weak self] in
                self?.viewModel.preloadDataIfRequired()
            }
        } else {
            hideErrorView()
        }
    }
}
