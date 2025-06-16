//
//  LogDetailView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI

struct LogDetailView: View {
    @Binding var log: HabitCompletionLog
    
    @Environment(\.dismiss) var dismiss
    
    // --- 1. NEW: A state variable to hold the currently selected sheet height. ---
    // We initialize it to .medium, which will be our default.
    @State private var selectedDetent: PresentationDetent = .medium
    
    private let moods = ["😊 Happy", "🧘 Calm", "⚡️ Energized", "💪 Strong", "✅ Satisfied"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("How did you feel?")) {
                    Picker("Mood", selection: $log.mood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood).tag(mood as String?)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
                
                Section(header: Text("Journal Entry (Optional)")) {
                    TextEditor(text: Binding(
                        get: { log.journalEntry ?? "" },
                        set: { log.journalEntry = $0 }
                    ))
                    .frame(height: 150)
                }
            }
            .navigationTitle("Add Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.secondary)
                }
            }
            // --- 2. UPDATED: We now bind the 'selection' to our state variable. ---
            // This explicitly tells SwiftUI to start with the detent we specified.
            .presentationDetents([.medium, .large], selection: $selectedDetent)
        }
    }
}
