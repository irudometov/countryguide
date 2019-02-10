//
//  UIView+LoadFromNib.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>(nibNameOrNil: String? = nil) -> T? {
        
        let nibName = nibNameOrNil ?? String(describing: self.classForCoder())
        let owner = self.init()
        
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)?.first as? T
    }
}
