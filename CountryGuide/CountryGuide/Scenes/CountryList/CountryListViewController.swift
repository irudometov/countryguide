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

final class CountryListViewController: TypedViewController<CountryListViewModel>, IErrorViewContainer, IStateTableView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // IErrorViewContainer
    var errorView: ErrorView?
    
    // IStateViewModel
    private let disposeBag = DisposeBag()
    
    // Delegate
    var didSelectCountry: ((Country) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisppear()
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
                self.viewModel.refreshData()
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
        
        // Table view
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        // Register cell
        
        let nib = UINib(nibName: "CountryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
        
        viewModel.countries
        .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: CountryTableViewCell.reuseIdentifier,
                                         cellType: CountryTableViewCell.self)) { (_, country, cell) in
                cell.countryNameLabel.text = country.name
                cell.countryPopulationLabel.text = country.populationString
                
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Country.self)
            .bind(onNext: { [weak self] country in
                
                guard let this = self else { return }
                
                if let indexPath = this.tableView.indexPathForSelectedRow {
                    this.tableView.deselectRow(at: indexPath, animated: true)
                }
                
                this.didSelectCountry?(country)
            })
            .disposed(by: disposeBag)
        
        // State
        
        viewModel.state
            .asObservable()
            .subscribe( { [weak self] event in
                guard let state = event.element else { return }
                self?.applyState(state)
            })
            .disposed(by: disposeBag)
    }
}
