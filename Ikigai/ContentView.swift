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
    
    // --- DELETED: The entire init() block and NavigationView have been removed. ---
    
    var body: some View {
        // The view now starts directly with the List.
        List {
            ForEach(viewModel.habits) { habit in
                HabitRowView(
                    habit: habit,
                    isCompleted: viewModel.isHabitCompletedToday(habitID: habit.id),
                    onToggleCompletion: {
                        viewModel.toggleCompletion(for: habit)
                    }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: viewModel.deleteHabit)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(Theme.background)
        // All .navigationTitle, .toolbar, and .toolbarBackground modifiers have been removed from this file.
        // Sheets and confetti are still triggered from here.
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
