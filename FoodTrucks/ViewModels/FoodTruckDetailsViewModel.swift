//
//  FoodTruckDetailsViewModel.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Foundation

///
/// A view model for displaying details about a FoodTruck model.
///
struct FoodTruckDetailsViewModel: Hashable {
    let foodTruck: FoodTruck

    var name: String { foodTruck.name }
    var location: String { foodTruck.location }
    var details: String? { foodTruck.details }
    var times: String { "\(foodTruck.startTime) - \(foodTruck.endTime)" }   // Times are displayed in the San Francisco timezone, regardless of the device's timezone.
}
