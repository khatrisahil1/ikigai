//
//  HabitDetailView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//  This view displays detailed information about a specific habit, including its description and a history of completions.
import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var viewModel: ContentViewModel
    let habit: Habit
    
    // A computed property to get only the completions for this specific habit
    private var filteredCompletions: [HabitCompletionLog] {
        viewModel.completions
            .filter { $0.habitId == habit.id }
            .sorted { $0.date > $1.date } // Show the most recent first
    }
    
    var body: some View {
        List {
            // Section for the habit's main description
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(habit.name)
                        .font(.title2.bold())
                    
                    if let description = habit.description, !description.isEmpty {
                        Text(description)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical)
            }
            
            // Section for the history of completions
            Section(header: Text("Completion History")) {
                if filteredCompletions.isEmpty {
                    Text("You haven't completed this habit yet. Let's get started!")
                        .foregroundColor(.gray)
                } else {
                    ForEach(filteredCompletions) { log in
                        VStack(alignment: .leading, spacing: 8) {
                            // Display the date
                            Text(log.date, style: .date)
                                .fontWeight(.bold)
                            
                            // Display the mood, if it exists
                            if let mood = log.mood {
                                Text(mood)
                            }
                            
                            // Display the journal entry, if it exists
                            if let journal = log.journalEntry, !journal.isEmpty {
                                Text(journal)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
