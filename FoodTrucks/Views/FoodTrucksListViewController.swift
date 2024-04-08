//
//  FoodTrucksListViewController.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Combine
import UIKit

class FoodTrucksListViewController: UIViewController, RequiresFoodTrucksViewModel {

    // Injected from FoodTrucksViewController
    weak var viewModel: FoodTrucksViewModel! {
        didSet {
            if let viewModel = viewModel {
                bindToViewModel(viewModel)
            }
        }
    }

    typealias FoodTrucksDataSource = UITableViewDiffableDataSource<Int, FoodTruckDetailsViewModel>
    private var dataSource: FoodTrucksDataSource?

    private var viewModelBinding: AnyCancellable?

    @IBOutlet weak var tableView: UITableView!

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = FoodTrucksDataSource(tableView: tableView) { tableView, indexPath, foodTruckDetails in
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodTruckDetailsViewTableCell.reuseIdentifier, for: indexPath) as? FoodTruckDetailsViewTableCell
            cell?.displayFoodTruckDetails(foodTruckDetails)
            return cell
        }

        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    // MARK: Internals

    private func bindToViewModel(_ viewModel: FoodTrucksViewModel) {
        viewModelBinding = viewModel.foodTruckDetails       // Reassignment of viewModelBinding will release any previous cancellable.
            .sink { [weak self] _ in
                self?.refreshDataSourceSnapshot()
        }
    }

    private func refreshDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FoodTruckDetailsViewModel>()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.foodTruckDetails.value)

        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

extension FoodTrucksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let foodTruck = dataSource?.itemIdentifier(for: indexPath)?.foodTruck {
            (parent as? FoodTrucksViewController)?.selectFoodTruckOnMap(foodTruck)
        }
    }
}
