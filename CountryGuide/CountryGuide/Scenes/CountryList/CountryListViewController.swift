//
//  CountryListViewController.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 05/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CountryListViewController: UITableViewController {
    
    private var viewModel: CountryListViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - New instance
    
    class func newInstance(viewModel: CountryListViewModel) -> CountryListViewController {
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "country-list") as? CountryListViewController else {
            fatalError("Fail to instantiate a view controller with identifier 'country-list' from a storyboard 'Main'.")
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
            }
            .disposed(by: disposeBag)
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.countries
        .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: CountryListTableViewCell.reuseIdentifier, cellType: CountryListTableViewCell.self)) { (_, country, cell) in
                
                cell.textLabel?.text = country.name
                cell.detailTextLabel?.text = String(country.population)
                
        }.disposed(by: disposeBag)
    }
}
