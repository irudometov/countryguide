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
