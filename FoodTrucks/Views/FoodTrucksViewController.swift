//
//  FoodTrucksViewController.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Combine
import UIKit

/// The app's main view controller.
///
/// This view controller serves as a container for the Food Trucks List and Map
/// views, as represented in the `ViewStyle` enum.
///
class FoodTrucksViewController: UIViewController {

    // In a "real" app, this would be injectable.
    let viewModel: FoodTrucksViewModel

    // The different view styles that this container view supports.
    enum ViewStyle {
        case list
        case map
    }

    // The active view style. Set this to determine the initially visible style.
    private(set) var viewStyle: ViewStyle = .list

    private var cancellables = Set<AnyCancellable>()

    // MARK: IB Outlets

    @IBOutlet weak var viewStyleButton: UIBarButtonItem!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var mapsContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var noTrucksLabel: UILabel!

    weak var mapViewController: FoodTrucksMapViewController?

    // MARK: Initialization

    required init?(coder: NSCoder) {
        viewModel = FoodTrucksViewModel()
        super.init(coder: coder)
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        noTrucksLabel.isHidden = true

        // Assign view models to child view controllers.
        children
            .compactMap { $0 as? RequiresFoodTrucksViewModel }
            .forEach {
                $0.viewModel = self.viewModel

                if let vc = $0 as? FoodTrucksMapViewController {
                    self.mapViewController = vc
                }
            }

        viewModel.downloading
            .sink { [weak self] active in
                active ? self?.activityIndicatorView.startAnimating() : self?.activityIndicatorView.stopAnimating()

                switch active {
                case true:
                    self?.activityIndicatorView.startAnimating()
                    self?.noTrucksLabel.isHidden = true
                case false:
                    self?.activityIndicatorView.stopAnimating()
                    self?.noTrucksLabel.isHidden = !(self?.viewModel.foodTruckDetails.value.isEmpty ?? false)
                }
            }
            .store(in: &cancellables)

        transitionToViewStyle(viewStyle)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewIsReady()
    }

    func selectFoodTruckOnMap(_ foodTruck: FoodTruck) {
        mapViewController?.selectFoodTruck(foodTruck)
        changeViewStyle(nil)
    }

    // MARK: IB Actions

    @IBAction func changeViewStyle(_ sender: Any?) {
        defer { transitionToViewStyle(viewStyle) }

        switch viewStyle {
        case .list:
            viewStyle = .map
        case .map:
            viewStyle = .list
        }
    }

    // MARK: Internals

    private func transitionToViewStyle(_ viewStyle: ViewStyle) {
        listContainerView.isHidden = true
        mapsContainerView.isHidden = true

        // The bar button title should be opposite from the active view style.
        switch viewStyle {
        case .list:
            viewStyleButton.title = NSLocalizedString("Map", comment: "")
            listContainerView.isHidden = false
        case .map:
            viewStyleButton.title = NSLocalizedString("List", comment: "")
            mapsContainerView.isHidden = false
        }
    }
}

protocol RequiresFoodTrucksViewModel: AnyObject {
    var viewModel: FoodTrucksViewModel! { get set }
}
