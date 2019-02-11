//
//  ErrorView.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 10/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ErrorView: UIView & IErrorView {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!
    
    var text: String? {
        get {
            return textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    
    var onRetry: (() -> Void)? = nil {
        didSet {
            buttonRetry.isHidden = onRetry == nil
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
        setupBindings()
    }
    
    private func reset() {
        textLabel?.text = nil
    }
    
    private func setupBindings() {
        
        buttonRetry.rx
            .tap
            .bind { [weak self] in
                self?.onRetry?()
            }
            .disposed(by: disposeBag)
    }
}
