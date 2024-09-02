//
//  PerformanceHistoryGraph.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import Foundation
import SwiftUI

struct PerformanceHistoryGraph: View {
    @Binding var history: [Performance]
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(mainColor)
            
            Text("Most Recent Performance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .kerning(-0.5)
            
            Spacer(minLength: 0)
        }
        .padding()
        .hAlign(.leading)
        
        VStack {
            
            if history.isEmpty {
                
                Text("No Performance History")
                    .font(.headline)
                    .padding()
                    .primaryTextStyleForeground()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            } else {
                
                GraphView()
                    
            }
        }
        .frame(minHeight: 190)
        .padding(.horizontal)
        .padding([.top, .bottom])
        .background(Color.gray.opacity(0.07).gradient)
        .cornerRadius(15)
    }
    
    
    @ViewBuilder
    private func GraphView() -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line))%")
                                .font(.system(size: 10))
                                .foregroundColor(.primary)
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -15)
                    }
                }
                
                HStack {
                    ForEach(history, id: \.self) { performance in
                        VStack(spacing: 0) {
                            VStack(spacing: 5) {
                                Capsule()
                                    .fill(mainColor)
                                    .frame(width: 8, height: getBarHeight(point: performance.score, size: proxy.size) * 0.5) // Assuming you want half-height for main color
                                
                                Capsule()
                                    .fill(subColor)
                                    .frame(width: 8, height: getBarHeight(point: performance.score, size: proxy.size) * 0.5) // Assuming you want half-height for sub color
                            }
                            .frame(width: 8)
                            .frame(height: getBarHeight(point: performance.score, size: proxy.size))
                            
                            Text(formatDate(performance.date))
                                .font(.system(size: 10))
                                .foregroundColor(.primary)
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 190)
    }
    
    
    /// Calculate the spacing between bars based on the number of items and available width
    private func calculateSpacing(for itemCount: Int, in totalWidth: CGFloat) -> CGFloat {
        let barWidth: CGFloat = 8
        let totalBarWidth = CGFloat(itemCount) * barWidth
        let totalSpacingWidth = totalWidth - totalBarWidth
        let spaceBetweenBars = max(10, totalSpacingWidth / CGFloat(itemCount + 1))  // Ensure a minimum spacing of 10
        return spaceBetweenBars
    }

    
    func getGraphLines() -> [CGFloat] {
        // Always use a maximum of 100 for the graph lines
        var _: CGFloat = 100
        var lines: [CGFloat] = []
        for index in 0...4 {
            lines.append(CGFloat(100 - 25 * index)) // Adding lines for 100%, 75%, 50%, 25%, and 0%
        }
        return lines
    }

    private func getMax() -> CGFloat {
        // Use static 100 as the max for bar height calculations
        return 100
    }

    func getBarHeight(point: CGFloat, size: CGSize) -> CGFloat {
        let maximumScore = getMax()  // Using the same maximum score function
        let height = (point / maximumScore) * (size.height - 37)  // Calculate the proportional height
        let minHeight: CGFloat = 2.0  // Define a minimum visible height for the bars
        return max(minHeight, height)  // Ensure bars are at least minHeight high
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            // Same day: Show hour and AM/PM
            dateFormatter.dateFormat = "h a"  // "1 PM", "3 AM"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) && calendar.isDate(date, equalTo: now, toGranularity: .year) {
            // Same week: Show abbreviated day of the week
            dateFormatter.dateFormat = "EEE"  // "Mon", "Tue", "Wed"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            // Same year but older than this week: Show abbreviated month
            dateFormatter.dateFormat = "MMM"  // "Aug", "Jul"
            return dateFormatter.string(from: date)
        } else {
            // Older than the current year
            return "Earlier"
        }
    }
}

#Preview {
    @State var history = mockHistory
    return PerformanceHistoryGraph(
        history: $history,
        mainColor: .teal,
        subColor: .themePurpleLight
    )
    .preferredColorScheme(.dark)
}



