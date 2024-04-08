//
//  FoodTruckDetailsView.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import UIKit

///
/// A view that displays a Food Truck's details.
///
class FoodTruckDetailsView: UIView {

    weak var nameLabel: UILabel?
    weak var locationLabel: UILabel?
    weak var detailsLabel: UILabel?
    weak var timesLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }

    func displayFoodTruckDetails(_ details: FoodTruckDetailsViewModel) {
        nameLabel?.text = details.name
        locationLabel?.text = details.location
        detailsLabel?.text = details.details
        timesLabel?.text = details.times
    }

    private func createSubviews() {
        backgroundColor = .systemBackground

        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.numberOfLines = 0

        let locationLabel = UILabel()
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationLabel.numberOfLines = 0

        let detailsLabel = UILabel()
        detailsLabel.font = .preferredFont(forTextStyle: .caption2)
        detailsLabel.numberOfLines = 0

        let vStack = UIStackView(arrangedSubviews: [nameLabel, locationLabel, detailsLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.distribution = .fill

        let timesLabel = UILabel()
        timesLabel.font = .preferredFont(forTextStyle: .headline)
        timesLabel.textAlignment = .right
        timesLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // 2-col h-stack
        let hStack = UIStackView(arrangedSubviews: [vStack, timesLabel])
        hStack.axis = .horizontal
        hStack.spacing = UIStackView.spacingUseSystem
        hStack.alignment = .center
        hStack.distribution = .fill

        addSubview(hStack)

        hStack.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            hStack.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: hStack.trailingAnchor, multiplier: 1.0),
            hStack.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
            bottomAnchor.constraint(equalToSystemSpacingBelow: hStack.bottomAnchor, multiplier: 1.0)
        ])

        self.nameLabel = nameLabel
        self.locationLabel = locationLabel
        self.detailsLabel = detailsLabel
        self.timesLabel = timesLabel
    }
}
