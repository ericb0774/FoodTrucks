//
//  FoodTrucksMapViewController.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Combine
import MapKit
import UIKit

class FoodTrucksMapViewController: UIViewController, RequiresFoodTrucksViewModel {

    // Injected from FoodTrucksViewController
    weak var viewModel: FoodTrucksViewModel! {
        didSet {
            if let viewModel = viewModel {
                bindToViewModel(viewModel)
            }
        }
    }

    private var viewModelBinding: AnyCancellable?

    @IBOutlet weak var mapView: MKMapView!
    weak var foodTruckDetailsView: FoodTruckDetailsView?

    func selectFoodTruck(_ foodTruck: FoodTruck) {
        if let annotation = mapView.annotations.first(where: {
            ($0 as? FoodTruckMapAnnotation)?.foodTruck == foodTruck
        })
        {
            mapView.selectAnnotation(annotation, animated: true)
            mapView.showAnnotations([annotation], animated: true)
        }
    }

    // MARK: Internals

    private func bindToViewModel(_ viewModel: FoodTrucksViewModel) {
        viewModelBinding = viewModel.foodTruckDetails       // Reassignment of viewModelBinding will release any previous cancellable.
            .sink { [weak self] _ in
                dispatchPrecondition(condition: .onQueue(.main))
                self?.refreshMap()
            }
    }

    private func refreshMap() {
        // Remove existing annotations first, if any.
        mapView.removeAnnotations(mapView.annotations)

        let annotations = viewModel.foodTruckDetails.value.map {
            FoodTruckMapAnnotation(foodTruck: $0.foodTruck)
        }

        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: false)
    }

    private func displayFoodTruckDetails(_ viewModel: FoodTruckDetailsViewModel) {
        let detailsView = foodTruckDetailsView ?? FoodTruckDetailsView()
        detailsView.displayFoodTruckDetails(viewModel)

        if self.foodTruckDetailsView == nil {
            // Adding the details view to our view tree for the first time.
            view.addSubview(detailsView)
            foodTruckDetailsView = detailsView

            detailsView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                detailsView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0)
            ])

            // We also need a view to stretch into the bottom safe area to cover
            // the map portion showing below the details view.
            let coverView = UIView()
            coverView.backgroundColor = .systemBackground
            view.addSubview(coverView)

            coverView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                coverView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor),
                coverView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor),
                coverView.topAnchor.constraint(equalTo: detailsView.bottomAnchor),
                coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            view.bringSubviewToFront(detailsView)
        }

        foodTruckDetailsView = detailsView
    }
}

extension FoodTrucksMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? FoodTruckMapAnnotation {
            displayFoodTruckDetails(FoodTruckDetailsViewModel(foodTruck: annotation.foodTruck))
        }
    }
}
