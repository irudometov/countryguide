//
//  CurrencyTableViewCell.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {
    
    static let reusetIdentifier = "currency"
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
}
