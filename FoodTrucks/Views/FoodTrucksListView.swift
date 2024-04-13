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

    var body: some View {
        NavigationView {
            List {
                ForEach(foodTrucks, id: \.foodTruck) { truck in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(truck.name).font(.headline)
                            Text(truck.location).font(.subheadline)

                            if let details = truck.details {
                                Text(details).font(.caption2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                        Text(truck.times).font(.headline)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Food Trucks")
        }
    }
}

#Preview {
    MainView(viewModel: FoodTrucksViewModel())
}
