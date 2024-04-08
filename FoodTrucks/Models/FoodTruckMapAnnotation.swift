//
//  FoodTruckMapAnnotation.swift
//  FoodTrucks
//
//  Created by Eric Baker on 22.Apr.2022.
//

import Foundation
import MapKit

///
/// Map annotation wrapper for representing food truck models on a MapKitView.
///
class FoodTruckMapAnnotation: NSObject, MKAnnotation {
    let foodTruck: FoodTruck

    init(foodTruck: FoodTruck) {
        self.foodTruck = foodTruck
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: foodTruck.latitude, longitude: foodTruck.longitude)
    }
}
