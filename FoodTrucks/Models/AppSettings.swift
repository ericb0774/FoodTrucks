//
//  AppSettings.swift
//  FoodTrucks
//
//  Created by Eric Baker on 24.Apr.2022.
//

import Foundation

@propertyWrapper
struct AppSettings<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get { container.object(forKey: key) as? Value ?? defaultValue }
        set { container.set(newValue, forKey: key) }
    }
}
