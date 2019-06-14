//
//  CountryDetailsViewController.swift
//  CountryGuide
//
//  Created by Ilya Rudometov on 07/02/2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

final class CountryDetailsViewController: UIViewController, IErrorViewContainer, IStateTableView, Coordinated {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var coordinator: Coordinator?
    
    // IErrorViewContainer
    var errorView: ErrorView?
    
    // IStateViewModel
    var viewModel: CountryDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, CountryPropertyCellModel>> {
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, CountryPropertyCellModel>> (
            configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
                
                switch model {
                    
                    // Basic info
                    
                case .basicInfo(let summary):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryBasicInfoTableViewCell.reusetIdentifier, for: indexPath) as? CountryBasicInfoTableViewCell else {
                        fatalError("Unsupported cell type: \(CountryBasicInfoTableViewCell.self) for row at index path \(indexPath)")
                    }
                    cell.countryNameLabel.text = summary.countryName
                    cell.capitalLabel.text = summary.capital
                    cell.populationLabel.text = summary.population
                    return cell
                    
                    // Section title
                    
                case .sectionTitle(let text):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleTableViewCell.reusetIdentifier, for: indexPath) as? SectionTitleTableViewCell else {
                        fatalError("Unsupported cell type: \(SectionTitleTableViewCell.self) for row at index path \(indexPath)")
                    }
                    cell.titleLabel.text = text
                    return cell
                    
                    // Currency
                    
                case .currency(let model):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reusetIdentifier, for: indexPath) as? CurrencyTableViewCell else {
                        fatalError("Unsupported cell type: \(CurrencyTableViewCell.self) for row at index path \(indexPath)")
                    }
                    cell.currencyNameLabel.text = model.currencyName
                    cell.currencySymbolLabel.text = model.currencySymbol
                    return cell
                    
                    // Border country
                    
                case .border(let country):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier, for: indexPath) as? CountryTableViewCell else {
                        fatalError("Unsupported cell type: \(CountryTableViewCell.self) for row at index path \(indexPath)")
                    }
                    cell.countryNameLabel.text = country.name
                    cell.countryPopulationLabel.text = country.populationString
                    cell.selectionStyle = .none
                    return cell
                }
        })
        
        // Configure animations
        
        dataSource.decideViewTransition = { _, _, _ in
            return .reload
        }
        
        return dataSource
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisppear()
    }
    
    private func setupBindings() {
        
        // Title
        
        viewModel.title
            .asObservable()
            .bind { [weak self] text in
                self?.title = text
            }
            .disposed(by: disposeBag)
        
        // State
        
        viewModel.state
            .asObservable()
            .subscribe( { [weak self] event in
                guard let state = event.element else { return }
                self?.applyState(state)
            })
            .disposed(by: disposeBag)
        
        // Table view
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        // Register cell
        
        let nib = UINib(nibName: "CountryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
