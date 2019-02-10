//
//  BorderCountryTableViewCell.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class BorderCountryTableViewCell: UITableViewCell {
    
    static let reusetIdentifier = "border-country"
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryPopulatioLabel: UILabel!
}
