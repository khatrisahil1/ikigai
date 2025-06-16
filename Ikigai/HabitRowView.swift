//
//  HabitRowView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 15/06/25.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    
    let isCompleted: Bool
    let onToggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                onToggleCompletion()
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? Theme.secondary : .gray.opacity(0.5))
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                    // --- NEW: Add strikethrough when completed ---
                    .strikethrough(isCompleted, color: Theme.text.opacity(0.6))
                
                if let description = habit.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(Theme.text.opacity(0.7))
                        // --- NEW: Add strikethrough here as well ---
                        .strikethrough(isCompleted, color: Theme.text.opacity(0.6))
                }
            }
            .opacity(isCompleted ? 0.7 : 1.0) // Adjusted opacity for better balance
            
            Spacer()
            
            Text("\(habit.experiencePoints) XP")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Theme.secondary.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(Theme.secondary)
                .opacity(isCompleted ? 0.7 : 1.0)
        }
        .padding()
        .background(Theme.background)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    VStack(spacing: 15) {
        HabitRowView(habit: Habit(name: "Incomplete Habit", description: "This is a test."), isCompleted: false, onToggleCompletion: {})
        HabitRowView(habit: Habit(name: "Completed Habit", description: "This is also a test."), isCompleted: true, onToggleCompletion: {})
        HabitRowView(habit: Habit(name: "Completed Habit", description: "This is also a test."), isCompleted: false, onToggleCompletion: {})
    }
    .padding()
    .background(Theme.background)
}
