//
//  PerformanceHistoryGraph.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/20/24.
//

import Foundation
import SwiftUI

struct PerformanceHistoryGraph: View {
    var history = [Performance]()
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
    
        HStack{
            Text("Performance History")
                .foregroundStyle(.primary)
                .fontWeight(.bold)
                .kerning(-0.5)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
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
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    private func GraphView() -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line))%")
                                .font(.caption)
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
                            
                            Text("Q:\(performance.numberOfQuestions)")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 190)
    }
    
    @ViewBuilder
    private func GraphView2() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                // Background grid lines and labels
                VStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line))%")
                                .font(.caption)
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

                // Bars for performances
                HStack(spacing: calculateSpacing(for: history.count, in: proxy.size.width)) {
                    ForEach(history, id: \.self) { performance in
                        VStack(spacing: 0) {
                            VStack(spacing: 5) {
                                Capsule()
                                    .fill(mainColor)
                                    .frame(width: 8, height: getBarHeight(point: performance.score, size: proxy.size) * 0.5)
                                
                                Capsule()
                                    .fill(subColor)
                                    .frame(width: 8, height: getBarHeight(point: performance.score, size: proxy.size) * 0.5)
                            }
                            .frame(width: 8, height: getBarHeight(point: performance.score, size: proxy.size))
                            
                            Text("Q:\(performance.numberOfQuestions)")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.horizontal, 30)
            }
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
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) && calendar.isDate(date, equalTo: now, toGranularity: .year) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: date)
        } else {
            return "Earlier"
        }
    }
}

