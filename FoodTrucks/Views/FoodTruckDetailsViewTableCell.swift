//
//  FoodTruckDetailsViewTableCell.swift
//  FoodTrucks
//
//  Created by Eric Baker on 22.Apr.2022.
//

import UIKit

class FoodTruckDetailsViewTableCell: UITableViewCell {
    class var reuseIdentifier: String { "FoodTruckDetailsViewTableCell" }

    private weak var detailsView: FoodTruckDetailsView!

    override func awakeFromNib() {
        super.awakeFromNib()

        createDetailsView()
    }

    func displayFoodTruckDetails(_ viewModel: FoodTruckDetailsViewModel) {
        detailsView?.displayFoodTruckDetails(viewModel)
    }

    private func createDetailsView() {
        let view = FoodTruckDetailsView(frame: .zero)
        contentView.addSubview(view)
        detailsView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
