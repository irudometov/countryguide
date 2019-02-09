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

protocol CountryListDelegate: NSObjectProtocol {
    func didSelectCountry(_ country: Country)
}

final class CountryListViewController: UITableViewController {
    
    private var viewModel: CountryListViewModel!
    private let disposeBag = DisposeBag()
    
    weak var delegate: CountryListDelegate?
    
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
        setupRefreshControl()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
    }
    
    private func setupBindings() {
        
        // Title
        
        viewModel.title
            .asObservable()
            .bind { [weak self] text in
                self?.title = text
            }
            .disposed(by: disposeBag)
        
        // Table view
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.countries
        .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: CountryListTableViewCell.reuseIdentifier, cellType: CountryListTableViewCell.self)) { (_, country, cell) in
                
                cell.textLabel?.text = country.name
                cell.detailTextLabel?.text = String(country.population)
                
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Country.self)
            .subscribe({ [weak self] value in
                
                guard let this = self,
                    let country = value.element,
                    let delegate = this.delegate else { return }
                
                delegate.didSelectCountry(country)
                
                if let indexPath = this.tableView.indexPathForSelectedRow {
                    this.tableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // Pull to refresh
        
        refreshControl?.rx.controlEvent(.valueChanged)
            .map { [unowned self] _ in self.refreshControl?.isRefreshing ?? false }
            .filter { $0 }
            .bind { [unowned self] isRefreshing in
                guard isRefreshing else { return }
                self.viewModel.refreshData() { [weak self] _ in
                    self?.refreshControl?.endRefreshing()                    
                }
            }
            .disposed(by: disposeBag)
    }
}
