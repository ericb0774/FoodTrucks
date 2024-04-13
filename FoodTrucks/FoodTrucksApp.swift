//
//  FoodTrucksApp.swift
//  FoodTrucks
//
//  Created by Eric Baker on 2024.04.12.
//

import SwiftUI

@main
struct FoodTrucksApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: FoodTrucksViewModel())
        }
    }

    static var runningInPreviewMode: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
