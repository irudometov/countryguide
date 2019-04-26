//
//  CountryTableViewCell.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "country"
 
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryPopulationLabel: UILabel!
}
