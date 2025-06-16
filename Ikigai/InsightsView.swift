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
        Form {
            Section(header: Text("Your Progress")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Level \(viewModel.userProfile.level)")
                        .font(.title.bold())
                        .foregroundColor(Theme.secondary)
                    
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
                    .tint(Theme.secondary)
                }
                .padding(.vertical)
            }
            
            Section(header: Text("Statistics")) {
                Text("More stats coming soon!")
            }
        }
    }
}
