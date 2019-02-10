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

protocol CountryListDelegate: AnyObject {
    func didSelectCountry(_ country: Country)
}

final class CountryListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
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
        guard let tableView = tableView else { return }
        
        if tableView.refreshControl == nil {
            tableView.refreshControl = UIRefreshControl()
        }
        
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map { [unowned self] _ in self.tableView.refreshControl?.isRefreshing ?? false }
            .filter { $0 }
            .bind { [unowned self] isRefreshing in
                guard isRefreshing else { return }
                self.viewModel.refreshData() { [weak self] _ in
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        
        // Title
        
        viewModel.title
            .asObservable()
            .bind { [weak self] text in
                self?.title = text
            }
            .disposed(by: disposeBag)
        
        // Loading status
        
        viewModel.isLoading
            .asObservable()
            .bind { [weak self] isLoading in
                guard let this = self else { return }
                
                this.tableView.isHidden = isLoading
                
                if isLoading && !this.activityIndicator.isAnimating {
                    this.activityIndicator.startAnimating()
                } else if !isLoading && this.activityIndicator.isAnimating {
                    this.activityIndicator.stopAnimating()
                }
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
    }
}
