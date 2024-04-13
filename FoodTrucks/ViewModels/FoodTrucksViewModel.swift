//
//  FoodTrucksViewModel.swift
//  FoodTrucks
//
//  Created by Eric Baker on 22.Apr.2022.
//

import Combine
import UIKit

///
/// The view model for FoodTrucksViewController.
///
@MainActor
class FoodTrucksViewModel: ObservableObject {
    let apiClient: APIClient

    @Published var foodTruckDetails: [FoodTruckDetailsViewModel] = []
    @Published var downloading = false

    @AppSettings(key: "lastFoodTrucksDownloadHour", defaultValue: nil)
    var lastFoodTrucksDownloadHour: Int?

    private var cancellables = Set<AnyCancellable>()

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient

        self.observeNotifications()
    }

    func viewIsReady() {
        downloadFoodTrucksAvailableNow()
    }

    private func observeNotifications() {
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.refreshFoodTrucksDataIfNeeded()
            }
            .store(in: &cancellables)
    }

    /// Asynchronously requests food trucks currently in operation.
    private func downloadFoodTrucksAvailableNow() {
        guard !FoodTrucksApp.runningInPreviewMode else {
            foodTruckDetails = FoodTruck.sampleTrucks.map { FoodTruckDetailsViewModel(foodTruck: $0) }
            return
        }

        guard !downloading else { return }
        downloading = true

        Task {
            do {
                foodTruckDetails = try await apiClient.downloadFoodTruckList().map {
                    FoodTruckDetailsViewModel(foodTruck: $0)
                }

                lastFoodTrucksDownloadHour = Date().hour
                downloading = false
            }
            catch {
                print("download error: \(error)")
            }
        }
    }

    private func refreshFoodTrucksDataIfNeeded() {
        if let hour = Date().hour, hour != lastFoodTrucksDownloadHour {
            // Remove old data first.
            foodTruckDetails = []

            downloadFoodTrucksAvailableNow()
        }
    }
}
