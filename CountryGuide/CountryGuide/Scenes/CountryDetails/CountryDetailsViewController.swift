//
//  CountryDetailsViewController.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 07/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit
import RxSwift

final class CountryDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var bordersLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    
    private var viewModel: CountryDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - New instance
    
    class func newInstance(viewModel: CountryDetailsViewModel) -> CountryDetailsViewController {
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "country-details") as? CountryDetailsViewController else {
            fatalError("Fail to instantiate a view controller with identifier 'country-details' from a storyboard 'Main'.")
        }
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
    
    private func setupBindings() {
        
        viewModel.title
            .asObservable()
            .bind { [weak self] text in
                self?.title = text
                self?.nameLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.capital
            .asObservable()
            .bind { [weak self] text in
                self?.capitalLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.population
            .asObservable()
            .bind { [weak self] text in
                self?.populationLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.borders
            .asObservable()
            .bind { [weak self] text in
                self?.bordersLabel.text = text
            }
            .disposed(by: disposeBag)
        
        viewModel.currencies
            .asObservable()
            .bind { [weak self] text in
                self?.currenciesLabel.text = text
            }
            .disposed(by: disposeBag)
    }
}
