//
//  Habit.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 15/06/25.
//

import Foundation

// --- UPDATED: Add 'Equatable' to the list of protocols ---
struct Habit: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var description: String?
    var creationDate: Date = .now
    var experiencePoints: Int = 10
}

// --- UPDATED: Add 'Equatable' here as well ---
struct HabitCompletionLog: Identifiable, Codable, Equatable {
    var id = UUID()
    var habitId: UUID
    var date: Date
    var mood: String?
    var journalEntry: String?
}
