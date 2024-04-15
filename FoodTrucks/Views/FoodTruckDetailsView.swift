//
//  FoodTruckDetailsView.swift
//  FoodTrucks
//
//  Created by Eric Baker on 2024.04.14.
//

import SwiftUI

struct FoodTruckDetailsView: View {
    var foodTruckDetailsViewModel: FoodTruckDetailsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(foodTruckDetailsViewModel.name).font(.headline)
                Text(foodTruckDetailsViewModel.location).font(.subheadline)

                if let details = foodTruckDetailsViewModel.details {
                    Text(details).font(.caption2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            Text(foodTruckDetailsViewModel.times).font(.headline)
        }
    }
}

#Preview {
    MainView(viewModel: FoodTrucksViewModel())
}
