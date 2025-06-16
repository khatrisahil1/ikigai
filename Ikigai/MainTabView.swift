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
            .navigationTitle(selectedTab == 0 ? "Today's Habits" : "Insights")
            .toolbar {
                if selectedTab == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Level \(viewModel.userProfile.level)")
                            .font(.headline)
                            // --- UPDATED: Use the dynamic level color here as well ---
                            .foregroundColor(Theme.color(for: viewModel.userProfile.level))
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewModel.isShowingAddHabitSheet = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(Theme.secondary)
                        }
                    }
                }
            }
        }
    }
}
