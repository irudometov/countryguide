//
//  CountryPropertyCellModel.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import RxDataSources

enum CountryPropertyCellModel {
    
    case basicInfo(summary: CountrySummaryInfo)
    case sectionTitle(text: String)
    case currency(model: CurrencyCellModel)
    case border(country: Country)
}

extension CountryPropertyCellModel: IdentifiableType, Hashable {
    
    var identity: String {
        switch self {
        case .basicInfo(let summary):
            return "summary." + summary.countryName
        case .sectionTitle(let text):
            return "section." + text
        case .currency(let model):
            return "currency." + model.currencyName + model.currencySymbol
        case .border(let country):
            return "property." + country.name
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity.hash)
    }
    
    static func == (lhs: CountryPropertyCellModel, rhs: CountryPropertyCellModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
