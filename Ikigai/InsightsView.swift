//
//  InsightsView.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI

struct InsightsView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        // We will now use a Form to structure our stats nicely.
        Form {
            // --- Section for Gamification ---
            Section(header: Text("Your Progress")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Level \(viewModel.userProfile.level)")
                        .font(.title.bold())
                        .foregroundColor(Theme.secondary)
                    
                    Text("\(viewModel.userProfile.totalXP) Total XP")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // A visual progress bar for the current level
                    ProgressView(
                        value: Double(viewModel.userProfile.progressTowardsNextLevel),
                        total: 100.0
                    ) {
                        Text("Progress to Level \(viewModel.userProfile.level + 1)")
                    } currentValueLabel: {
                        Text("\(viewModel.userProfile.progressTowardsNextLevel) / 100 XP")
                    }
                    .tint(Theme.secondary) // Use our theme color for the bar
                }
                .padding(.vertical)
            }
            
            // --- Section for Overall Stats (more to come) ---
            Section(header: Text("Statistics")) {
                Text("More stats coming soon!")
            }
        }
    }
}
