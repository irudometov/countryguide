//
//  IStateViewModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 12/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxCocoa

protocol IStateViewModel {
    
    var state: BehaviorRelay<ViewModelState> { get }
    
    func preloadDataIfRequired()
}
