//
//  MainTabView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ContentView(viewModel: viewModel)
                    .tabItem {
                        Label("Habits", systemImage: "checklist")
                    }
                    .tag(0)
                
                InsightsView(viewModel: viewModel)
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar.xaxis")
                    }
                    .tag(1)
            }
            .navigationBarHidden(true) // Workaround for the visual glitch
        }
    }
}
