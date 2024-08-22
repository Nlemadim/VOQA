//
//  QuizCarouselView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import SwiftUI


struct QuizCarouselView: View {
    var quizzes: [Voqa]
    @Binding var currentItem: Int
    @Binding var backgroundImage: String
    let tapAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Picks")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            TabView(selection: $currentItem) {
                ForEach(quizzes.indices, id: \.self) { index in
                    let quiz = quizzes[index]
                    VStack(spacing: 8) {
                        // Display the image from the imageUrl
                        AsyncImage(url: URL(string: quiz.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 240, height: 240)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 240, height: 240)
                                    .cornerRadius(15.0)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 240, height: 240)
                                    .cornerRadius(15.0)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        Text(quiz.quizTitle)
                            .font(.callout)
                            .fontWeight(.black)
                            .lineLimit(3, reservesSpace: false)
                            .multilineTextAlignment(.center)
                            .frame(width: 180)
                            .padding(.horizontal, 8)
                            
                        Text("Users: \(quiz.users)")
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        if !quiz.curator.isEmpty {
                            Text("Curated by: \(quiz.curator)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= quiz.rating ? "star.fill" : "star")
                                    .imageScale(.small)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        tapAction()
                    }
                    .onAppear {
                        backgroundImage = quiz.imageUrl // Update background
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
        }
    }
}
