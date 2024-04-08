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

    private(set) var foodTruckDetails = CurrentValueSubject<[FoodTruckDetailsViewModel], Never>([])
    private(set) var downloading = PassthroughSubject<Bool, Never>()

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
        downloading.send(true)

        Task {
            do {
                foodTruckDetails.value = try await apiClient.downloadFoodTruckList().map {
                    FoodTruckDetailsViewModel(foodTruck: $0)
                }

                lastFoodTrucksDownloadHour = Date().hour
                downloading.send(false)
            }
            catch {
                print("download error: \(error)")
            }
        }
    }

    private func refreshFoodTrucksDataIfNeeded() {
        if let hour = Date().hour, hour != lastFoodTrucksDownloadHour {
            // Remove old data first.
            foodTruckDetails.send([])

            downloadFoodTrucksAvailableNow()
        }
    }
}
