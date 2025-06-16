import Foundation
import SwiftUI

struct MoodStat: Identifiable, Equatable {
    let id = UUID()
    let mood: String
    let count: Int
}

class ContentViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var completions: [HabitCompletionLog] = []
    @Published var userProfile = UserProfile()
    
    enum TimeFilter: String, CaseIterable, Identifiable {
        case today = "Today"
        case week = "This Week"
        case all = "All Time"
        var id: Self { self }
    }
    @Published var selectedTimeFilter: TimeFilter = .all
    
    @Published var isShowingAddHabitSheet = false
    @Published var selectedLogForDetail: HabitCompletionLog?
    @Published var isShowingConfetti: Bool = false
    
    enum SortOrder {
        case name, creationDate
    }
    @Published var sortOrder: SortOrder = .creationDate
    
    var sortedHabits: [Habit] {
        switch sortOrder {
        case .name:
            return habits.sorted { $0.name < $1.name }
        case .creationDate:
            return habits.sorted { $0.creationDate > $1.creationDate }
        }
    }
    
    private var filteredCompletions: [HabitCompletionLog] {
        switch selectedTimeFilter {
        case .today:
            return completions.filter { Calendar.current.isDateInToday($0.date) }
        case .week:
            guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: .now)) else {
                return []
            }
            return completions.filter { $0.date >= startOfWeek }
        case .all:
            return completions
        }
    }
    
    var totalCompletions: Int {
        return filteredCompletions.count
    }
    
    var uniqueDaysActive: Int {
        let uniqueDays = Set(filteredCompletions.map { Calendar.current.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
    
    var moodSummary: [MoodStat] {
        let moods = filteredCompletions.compactMap { $0.mood }
        let moodCounts = moods.reduce(into: [:]) { counts, mood in counts[mood, default: 0] += 1 }
        return moodCounts.map { MoodStat(mood: $0.key, count: $0.value) }.sorted { $0.count > $1.count }
    }
    
    var currentStreak: Int {
        guard !completions.isEmpty else { return 0 }
        let uniqueCompletionDays = Set(completions.map { Calendar.current.startOfDay(for: $0.date) })
        let sortedDays = uniqueCompletionDays.sorted(by: { $0 > $1 })
        
        guard let mostRecentDay = sortedDays.first,
              Calendar.current.isDateInToday(mostRecentDay) || Calendar.current.isDateInYesterday(mostRecentDay)
        else { return 0 }
        
        var streakCount = 0
        var currentDay = mostRecentDay
        
        for day in sortedDays {
            if Calendar.current.isDate(day, inSameDayAs: currentDay) {
                streakCount += 1
                currentDay = Calendar.current.date(byAdding: .day, value: -1, to: currentDay)!
            } else {
                break
            }
        }
        return streakCount
    }
    
    init() {
        loadData()
    }
    
    func deleteAllHabits() {
        habits.removeAll()
        completions.removeAll()
        userProfile = UserProfile()
        saveData()
    }
    
    func markAllAsComplete() {
        for habit in habits {
            if !isHabitCompletedToday(habitID: habit.id) {
                toggleCompletion(for: habit, showDetailSheet: false)
            }
        }
    }
    
    func toggleCompletion(for habit: Habit, showDetailSheet: Bool = true) {
        if isHabitCompletedToday(habitID: habit.id) {
            completions.removeAll { $0.habitId == habit.id && Calendar.current.isDateInToday($0.date) }
            if userProfile.totalXP >= habit.experiencePoints {
                userProfile.totalXP -= habit.experiencePoints
            }
        } else {
            let newCompletion = HabitCompletionLog(habitId: habit.id, date: .now)
            completions.append(newCompletion)
            userProfile.totalXP += habit.experiencePoints
            
            if showDetailSheet {
                selectedLogForDetail = newCompletion
            }
            
            let completedTodayCount = completions.filter { Calendar.current.isDateInToday($0.date) }.count
            
            if !habits.isEmpty && completedTodayCount == habits.count {
                SoundManager.shared.playSound(named: "TingSound", withExtension: "wav")
                isShowingConfetti = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isShowingConfetti = false
                }
            }
        }
        saveData()
    }
    
    func deleteHabit(at offsets: IndexSet) {
        let habitsToDelete = offsets.map { sortedHabits[$0] }
        let idsToDelete = habitsToDelete.map { $0.id }
        
        completions.removeAll { idsToDelete.contains($0.habitId) }
        habits.removeAll { idsToDelete.contains($0.id) }
        saveData()
    }
    
    func isHabitCompletedToday(habitID: UUID) -> Bool {
        completions.contains { $0.habitId == habitID && Calendar.current.isDateInToday($0.date) }
    }
    
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
            return nil
        }
    }
}
