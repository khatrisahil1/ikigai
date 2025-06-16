import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        List {
            ForEach(viewModel.sortedHabits) { habit in
                NavigationLink(destination: HabitDetailView(viewModel: viewModel, habit: habit)) {
                    HabitRowView(
                        habit: habit,
                        isCompleted: viewModel.isHabitCompletedToday(habitID: habit.id),
                        onToggleCompletion: {
                            viewModel.toggleCompletion(for: habit)
                        }
                    )
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: viewModel.deleteHabit)
            
            Spacer()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .frame(height: 60)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(Theme.background)
        .sheet(isPresented: $viewModel.isShowingAddHabitSheet) {
            AddHabitView { newHabit in
                viewModel.habits.append(newHabit)
            }
        }
        .sheet(item: $viewModel.selectedLogForDetail) { log in
            if let index = viewModel.completions.firstIndex(where: { $0.id == log.id }) {
                LogDetailView(log: $viewModel.completions[index])
            }
        }
        .confettiCannon(trigger: $viewModel.isShowingConfetti, num: 50, colors: [Theme.primary, Theme.secondary, Theme.accent], rainHeight: 400.0)
    }
}
