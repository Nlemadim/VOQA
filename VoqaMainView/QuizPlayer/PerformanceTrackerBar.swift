//
//  PerformanceTrackerBar.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/20/24.
//

import Foundation
import SwiftUI
import Combine

struct PerformanceTrackerBar: View {
    @ObservedObject var viewModel: PerformanceTrackerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Learning Progress Tracker")
                .foregroundStyle(.primary)
                .fontWeight(.bold)
                .kerning(-0.5) // Reduces the default spacing between characters
            
            Spacer(minLength: 0)
                .frame(height: 20) // Added spacer to provide some space below the title
            
            VStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            ForEach(0..<viewModel.sections, id: \.self) { index in
                                Rectangle()
                                    .fill(viewModel.colorForSection(index: index))
                                    .frame(width: geometry.size.width / CGFloat(viewModel.sections))
                            }
                        }
                        
                        Triangle(direction: viewModel.aggregateScore >= 0.5 ? .right : .left)
                            .fill(Color.red).activeGlow(.red, radius: 2)
                            .frame(width: 15, height: 15)
                            .shadow(radius: 15)
                            .offset(x: viewModel.triangleOffset(in: geometry.size.width))
                    }
                }
                .frame(height: 10)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            
            HStack {
                Text("Foundations")
                    .font(.caption)
                Spacer()
                Text("Expert")
                    .font(.caption)
            }
        }
        .padding()
    }
}

struct Triangle: Shape {
    enum Direction {
        case left, right
    }
    
    var direction: Direction
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch direction {
        case .left:
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        case .right:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        path.closeSubpath()
        return path
    }
}

class PerformanceTrackerViewModel: ObservableObject {
    @Published var performances: [Performance]
    
    let sections = 10 // Number of sections (Foundations to Expert)
    
    init(performances: [Performance]) {
        self.performances = performances
    }
    
    var aggregateScore: CGFloat {
        let totalScore = performances.reduce(0) { $0 + $1.score }
        let totalQuestions = performances.reduce(0) { $0 + $1.numberOfQuestions }
        return totalScore / CGFloat(totalQuestions)
    }
    
    func colorForSection(index: Int) -> Color {
        switch index {
        case 0, 1:
            return Color.green // Foundations
        case 2, 3:
            return Color.yellow // Beginner
        case 4, 5:
            return Color.orange // Intermediate
        case 6, 7:
            return Color.blue // Advanced
        case 8, 9:
            return Color.purple // Expert
        default:
            return Color.gray
        }
    }
    
    func triangleOffset(in totalWidth: CGFloat) -> CGFloat {
        let sectionWidth = totalWidth / CGFloat(sections)
        
        // Calculate the position based on the aggregate score
        let position = min(max(aggregateScore * CGFloat(sections), 0), CGFloat(sections - 1))
        
        return sectionWidth * position
    }
}

#Preview {
    let viewModel = PerformanceTrackerViewModel(performances: [
        Performance(id: UUID(), quizTitle: "Quiz 1", date: Date(), score: 0.7, numberOfQuestions: 10),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 0.8, numberOfQuestions: 10),
        // Add more performances as needed
    ])
    
    return PerformanceTrackerBar(viewModel: viewModel)
}

