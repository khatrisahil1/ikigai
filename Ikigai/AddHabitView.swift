//
//  AddHabitView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 15/06/25.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    var onSave: (Habit) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name (e.g., Drink Water)", text: $name)
                    TextField("Description (optional)", text: $description)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newHabit = Habit(name: name, description: description)
                        onSave(newHabit)
                        dismiss()
                    }
                    .foregroundColor(Theme.secondary)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
