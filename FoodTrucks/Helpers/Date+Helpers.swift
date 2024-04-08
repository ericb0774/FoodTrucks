//
//  Date+Helpers.swift
//  FoodTrucks
//
//  Created by Eric Baker on 24.Apr.2022.
//

import Foundation

extension Date {
    var hour: Int? {
        Calendar(identifier: .gregorian).dateComponents([.hour], from: self).hour
    }
}
