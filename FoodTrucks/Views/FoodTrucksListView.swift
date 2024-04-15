//
//  FoodTrucksListView.swift
//  FoodTrucks
//
//  Created by Eric Baker on 2024.04.12.
//

import SwiftUI

struct FoodTrucksListView: View {
    @Binding var foodTrucks: [FoodTruckDetailsViewModel]
    @Binding var selectedTab: MainView.Tab
    @Binding var selectedFoodTruckDetailsViewModel: FoodTruckDetailsViewModel?

    var body: some View {
        NavigationView {
            List(selection: $selectedFoodTruckDetailsViewModel) {
                ForEach(foodTrucks, id: \.foodTruck) { truck in
                    FoodTruckDetailsView(foodTruckDetailsViewModel: truck)
                        .tag(truck)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Food Trucks")
        }
        .onChange(of: selectedFoodTruckDetailsViewModel) {
            selectedTab = .map
        }
    }
}

#Preview {
    MainView(viewModel: FoodTrucksViewModel())
}
