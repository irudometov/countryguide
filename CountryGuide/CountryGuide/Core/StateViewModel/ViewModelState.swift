//
//  ViewModelState.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

enum ViewModelState {
    
    case initial
    case loading
    case ready
    case error(lastError: Error?)
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}

extension ViewModelState: Equatable {
    
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loading, .loading),
             (.error, .error),
             (.ready, .ready):
            return true
        default:
            return false
        }
    }
}
