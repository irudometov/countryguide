//
//  UIView+Frame.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

extension UIView {
    
    func setWidth(_ width: CGFloat) {
        assert(width >= 0, "Width (\(width)) should be greater or equal to zero.")
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func centerInSuperview() {
        guard let superview = superview else { return }        
        center = CGPoint(x: superview.bounds.width / 2,
                         y: superview.bounds.height / 2)
    }
}
