//
//  ContentViewModel.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var completions: [HabitCompletionLog] = []
    @Published var userProfile = UserProfile()
    
    @Published var isShowingAddHabitSheet = false
    @Published var selectedLogForDetail: HabitCompletionLog?
    
    @Published var isShowingConfetti: Bool = false
    
    init() {
        loadData()
    }
    
    // MARK: - Core Logic
    
    func toggleCompletion(for habit: Habit) {
        if isHabitCompletedToday(habitID: habit.id) {
            completions.removeAll { $0.habitId == habit.id && Calendar.current.isDateInToday($0.date) }
            if userProfile.totalXP >= habit.experiencePoints {
                userProfile.totalXP -= habit.experiencePoints
            }
        } else {
            let newCompletion = HabitCompletionLog(habitId: habit.id, date: .now)
            completions.append(newCompletion)
            userProfile.totalXP += habit.experiencePoints
            
            selectedLogForDetail = newCompletion
            
            let completedTodayCount = completions.filter { Calendar.current.isDateInToday($0.date) }.count
            
            if !habits.isEmpty && completedTodayCount == habits.count {
                SoundManager.shared.playSound(named: "TingSound")
                isShowingConfetti = true
                
                // --- THIS IS THE NEW FIX ---
                // We are resetting the trigger back to false after 2 seconds.
                // This allows the confetti to be triggered again in the future.
                // We use [weak self] as a good practice to prevent memory issues.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isShowingConfetti = false
                }
            }
        }
        saveData()
    }
    
    // All other functions remain the same...
    func deleteHabit(at offsets: IndexSet) {
        let habitsToDelete = offsets.map { habits[$0] }
        let idsToDelete = habitsToDelete.map { $0.id }
        
        completions.removeAll { idsToDelete.contains($0.habitId) }
        habits.remove(atOffsets: offsets)
        saveData()
    }
    
    func isHabitCompletedToday(habitID: UUID) -> Bool {
        completions.contains { $0.habitId == habitID && Calendar.current.isDateInToday($0.date) }
    }
    
    // MARK: - Data Persistence
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveData() {
        save(habits, to: "habits.json")
        save(completions, to: "completions.json")
        save(userProfile, to: "profile.json")
    }
    
    private func loadData() {
        self.habits = load(from: "habits.json") ?? []
        self.completions = load(from: "completions.json") ?? []
        self.userProfile = load(from: "profile.json") ?? UserProfile()
    }
    
    private func save<T: Codable>(_ data: T, to filename: String) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving data to \(filename): \(error.localizedDescription)")
        }
    }
    
    private func load<T: Codable>(from filename: String) -> T? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Could not load data from \(filename). This is normal on first launch.")
            return nil
        }
    }
}
