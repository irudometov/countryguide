//
//  CurrencyCellModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxDataSources

struct CurrencyCellModel {
    
    let currencyName: String
    let currencySymbol: String
    
    // MARK: - init
    
    init(currencyName: String,
         currencySymbol: String = "-") {
        
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
    }
}

extension CurrencyCellModel: IdentifiableType, Hashable {
    
    var hashValue: Int {
        return (currencyName + currencySymbol).hashValue
    }
    
    var identity: String { return String(hashValue) }
}
