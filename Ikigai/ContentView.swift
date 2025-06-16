//
//  ContentView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 15/06/25.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        // --- UPDATED: The list now uses NavigationLink to go to the detail view ---
        List {
            ForEach(viewModel.habits) { habit in
                // We wrap the entire row in a NavigationLink
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
