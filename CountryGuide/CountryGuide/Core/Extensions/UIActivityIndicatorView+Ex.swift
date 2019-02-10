//
//  UIActivityIndicatorView+Ex.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func animateLoading(_ isLoading: Bool) {
        if isLoading && !isAnimating {
            startAnimating()
        } else if !isLoading && isAnimating {
            stopAnimating()
        }
    }
}
