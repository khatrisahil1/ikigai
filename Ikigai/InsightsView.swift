import SwiftUI
import Charts

struct InsightsView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $viewModel.selectedTimeFilter) {
                ForEach(ContentViewModel.TimeFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
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
                        Text("Current Streak")
                        Spacer()
                        Text("\(viewModel.currentStreak) Days")
                            .fontWeight(.bold)
                    }
                    
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
                
                Section(header: Text("Mood Analysis")) {
                    if viewModel.moodSummary.isEmpty {
                        Text("Complete habits and log your mood to see your analysis here!")
                            .foregroundColor(.gray)
                            .padding(.vertical)
                    } else {
                        Chart(viewModel.moodSummary) { moodStat in
                            BarMark(
                                x: .value("Count", moodStat.count),
                                y: .value("Mood", moodStat.mood)
                            )
                            .foregroundStyle(by: .value("Mood", moodStat.mood))
                        }
                        .animation(.easeInOut, value: viewModel.moodSummary)
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: viewModel.moodSummary.map { $0.count }.max() ?? 1))
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
