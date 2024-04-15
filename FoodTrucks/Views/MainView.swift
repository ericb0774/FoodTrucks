//
//  MainView.swift
//  FoodTrucks
//
//  Created by Eric Baker on 2024.04.12.
//

import SwiftUI

struct MainView: View {
    @Bindable var viewModel: FoodTrucksViewModel

    @State var selectedTab: Tab = .list
    @State var selectedFoodTruckDetailsViewModel: FoodTruckDetailsViewModel?

    var body: some View {
        TabView(selection: $selectedTab) {
            FoodTrucksListView(foodTrucks: $viewModel.foodTruckDetails, selectedTab: $selectedTab, selectedFoodTruckDetailsViewModel: $selectedFoodTruckDetailsViewModel)
                .tabItem {
                    tabView(.list)
                }.tag(Tab.list)

            FoodTrucksMapView(foodTrucks: $viewModel.foodTruckDetails, selectedFoodTruckViewModel: $selectedFoodTruckDetailsViewModel)
                .tabItem {
                    tabView(.map)
                }.tag(Tab.map)
        }
        .overlay {
            ActivityIndicatorView(isAnimating: $viewModel.downloading, style: .large)
        }
        .onAppear {
            viewModel.viewIsReady()
        }
    }

    @ViewBuilder
    func tabView(_ tab: Tab) -> some View {
        Image(systemName: tab.systemImageName)
        Text(tab.title)
    }
}

extension MainView {
    enum Tab: Int {
        case list
        case map

        var title: String {
            switch self {
            case .list: return "Food Trucks"
            case .map: return "Map"
            }
        }

        var systemImageName: String {
            switch self {
            case .list: return "truck.box.fill"
            case .map: return "map.fill"
            }
        }
    }
}

#Preview {
    MainView(viewModel: FoodTrucksViewModel())
}
