import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedTab = 0
    @State private var isShowingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ContentView(viewModel: viewModel, selectedTab: $selectedTab)
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
                        Button(action: { selectedTab = 1 }) {
                            Text("Level \(viewModel.userProfile.level)")
                                .font(.headline)
                                .foregroundColor(Theme.color(for: viewModel.userProfile.level))
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { viewModel.isShowingAddHabitSheet = true }) {
                            Image(systemName: "plus")
                        }
                        
                        Menu {
                            Section(header: Text("Sort By")) {
                                Button("Date Created", action: { viewModel.sortOrder = .creationDate })
                                Button("Name", action: { viewModel.sortOrder = .name })
                            }
                            
                            Button("Mark All as Complete", systemImage: "checkmark.circle.fill", action: { viewModel.markAllAsComplete() })
                            
                            Button("Delete All Habits", systemImage: "trash", role: .destructive, action: {
                                isShowingDeleteAlert = true
                            })
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert("Are you sure?", isPresented: $isShowingDeleteAlert) {
                Button("Delete All", role: .destructive) {
                    viewModel.deleteAllHabits()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all of your habits and progress. This action cannot be undone.")
            }
        }
    }
}
