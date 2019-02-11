//
//  StateViewModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 11/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxCocoa
import Reachability
import RxReachability
import RxSwift

class StateViewModel {
    
    let title = BehaviorRelay<String>(value: "")
    let state = BehaviorRelay<ViewModelState>(value: .initial)
    
    private var isReachable: Observable<Bool>?
    private let disposeBag = DisposeBag()
    
    // MARK: - View's life cycle
    
    func onViewWillAppear() {
        preloadDataIfRequired()
        startTrackingReachability()
    }
    
    func onViewWillDisppear() {
        stopTrackingReachability()
    }
    
    // MARK: - Preload data
    
    func preloadDataIfRequired() {
        
        // Override this method in derived classes...
    }
    
    // MARK: - Reachability
    
    func startTrackingReachability() {
        
        guard isReachable == nil else { return }
        
        isReachable =  Reachability.rx.isReachable.asObservable()
        isReachable?.bind(onNext: { [weak self] hasConnection in
            self?.reachabilityStatusChanged(isReachable: hasConnection)
        }).disposed(by: disposeBag)
    }
    
    func stopTrackingReachability() {
        isReachable = nil
    }
    
    func reachabilityStatusChanged(isReachable: Bool) {
        
        // Override this method in derived classes...
    }
}
