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
    @IBOutlet weak var countryPopulationLabelWidthConstraint: NSLayoutConstraint!
    
    private func adjustPopulationLabelWidth() {
        
        guard let widthConstraint = countryPopulationLabelWidthConstraint,
            let label = countryPopulationLabel else {
                return
        }
        
        widthConstraint.constant = label.intrinsicContentSize.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustPopulationLabelWidth()
    }
}
