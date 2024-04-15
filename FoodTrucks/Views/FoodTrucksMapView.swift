//
//  FoodTrucksMapView.swift
//  FoodTrucks
//
//  Created by Eric Baker on 2024.04.14.
//

import MapKit
import SwiftUI

struct FoodTrucksMapView: View {
    @Binding var foodTrucks: [FoodTruckDetailsViewModel]
    @Binding var selectedFoodTruckViewModel: FoodTruckDetailsViewModel?

    @State var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedFoodTruckViewModel) {
            ForEach(foodTrucks, id: \.foodTruck) { viewModel in
                let annotation = FoodTruckMapAnnotation(foodTruck: viewModel.foodTruck)

                Marker("", systemImage: "truck.box.fill", coordinate: annotation.coordinate)
                    .tag(viewModel)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let viewModel = selectedFoodTruckViewModel {
                HStack {
                    Spacer()
                    FoodTruckDetailsView(foodTruckDetailsViewModel: viewModel)
                        .padding()
                    Spacer()
                }
                .background(.thinMaterial)
            }
        }
        .onChange(of: selectedFoodTruckViewModel) {
            cameraPosition = .automatic
            if let foodTruck = selectedFoodTruckViewModel?.foodTruck {
                let coordinate = FoodTruckMapAnnotation(foodTruck: foodTruck).coordinate
                let placemark = MKPlacemark(coordinate: coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                cameraPosition = .item(mapItem)
            }
        }
    }
}

#Preview {
    MainView(viewModel: FoodTrucksViewModel(), selectedTab: .map)
}
