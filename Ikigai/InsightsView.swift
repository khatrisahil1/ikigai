//
//  InsightsView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI
// --- NEW: Import the Charts library ---
import Charts

struct InsightsView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Your Progress")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Level \(viewModel.userProfile.level)")
                        .font(.title.bold())
                        .foregroundColor(Theme.color(for: viewModel.userProfile.level))
                    
                    Text("\(viewModel.userProfile.totalXP) Total XP")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ProgressView(
                        value: Double(viewModel.userProfile.progressTowardsNextLevel),
                        total: 100.0
                    ) {
                        Text("Progress to Level \(viewModel.userProfile.level + 1)")
                    } currentValueLabel: {
                        Text("\(viewModel.userProfile.progressTowardsNextLevel) / 100 XP")
                    }
                    .tint(Theme.color(for: viewModel.userProfile.level))
                }
                .padding(.vertical)
            }
            
            Section(header: Text("Statistics")) {
                HStack {
                    Text("Total Completions")
                    Spacer()
                    Text("\(viewModel.totalCompletions)")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Active Days")
                    Spacer()
                    Text("\(viewModel.uniqueDaysActive)")
                        .fontWeight(.bold)
                }
            }
            
            // --- NEW: A section for our Mood Chart ---
            Section(header: Text("Mood Analysis")) {
                // Check if there is any mood data. If not, show a placeholder.
                if viewModel.moodSummary.isEmpty {
                    Text("Complete habits and log your mood to see your analysis here!")
                        .foregroundColor(.gray)
                        .padding(.vertical)
                } else {
                    // Create the chart with our mood summary data
                    Chart(viewModel.moodSummary) { moodStat in
                        // Each item in the summary becomes a BarMark.
                        BarMark(
                            x: .value("Count", moodStat.count),
                            y: .value("Mood", moodStat.mood)
                        )
                        // This gives each bar a distinct color automatically.
                        .foregroundStyle(by: .value("Mood", moodStat.mood))
                    }
                    // Add a nice animation when the data changes
                    .animation(.easeInOut, value: viewModel.moodSummary)
                    .frame(height: 150) // Give the chart a fixed height
                    .chartXAxis {
                        // This ensures the X-axis only shows whole numbers (e.g., 1, 2, 3)
                        AxisMarks(values: .automatic(desiredCount: viewModel.moodSummary.map { $0.count }.max() ?? 1))
                    }
                }
            }
        }
    }
}
