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
    
    // The init() block is a good place to configure the global appearance
    // of UI components like the Tab Bar.
    init() {
        // This makes sure the background is always applied, even in lists.
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
    }
    
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
            // --- NEW: These modifiers apply the frosted glass effect to the Tab Bar ---
            .toolbarBackground(.visible, for: .tabBar) // Ensures the background is always visible
            .toolbarBackground(.regularMaterial, for: .tabBar) // Applies the translucent material
        }
    }
}
