//
//  MyCollectionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

struct MyCollectionView: View {
    var quizzes: [QuizPackageProtocol]
    @Binding var currentItem: Int
    @ObservedObject var generator: ColorGenerator
    @Binding var backgroundImage: String
    let tapAction: () -> Void
    
    var body: some View {
        VStack {
            Text("My Collection")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .hAlign(.leading)
                .accessibilityAddTraits(.isHeader)
            
            TabView(selection: $currentItem) {
                Group {
                    if quizzes.isEmpty {
                        CustomContentUnavailableView(imageName: "IconImage")
                    } else {
                        ForEach(quizzes.indices, id: \.self) { index in
                            let quiz = quizzes[index]
                            VStack(spacing: 4) {
                                Image(quiz.titleImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 240, height: 240)
                                    .cornerRadius(15.0)
                                    .accessibilityLabel(Text("Quiz image"))

                                Text(quiz.title)
                                    .font(.callout)
                                    .fontWeight(.black)
                                    .lineLimit(3, reservesSpace: false)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 180)
                                    .padding(.horizontal, 8)
                                    .accessibilityLabel(Text(quiz.title))
                                
                                Text(quiz.edition.descr)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .hAlign(.center)
                                    .accessibilityLabel(Text(quiz.edition.descr))
                                
                                if let curator = quiz.curator {
                                    Text("Curated by: " + curator)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .hAlign(.center)
                                        .accessibilityLabel(Text("Curated by: \(curator)"))
                                }
                                
                                if let users = quiz.users {
                                    Text("Users: \(users)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .hAlign(.center)
                                        .accessibilityLabel(Text("Users: \(users)"))
                                }
                                
                                if let rating = quiz.rating {
                                    HStack {
                                        ForEach(1...5, id: \.self) { index in
                                            if index <= rating {
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                                    .accessibilityLabel(Text("Star filled"))
                                            } else {
                                                Image(systemName: "star")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.secondary)
                                                    .accessibilityLabel(Text("Star"))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom)
                            .onTapGesture {
                                tapAction()
                            }
                            .onAppear {
                                generator.updateAllColors(fromImageNamed: quiz.titleImage)
                                backgroundImage = quiz.titleImage // Update background
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
        }
    }
}




struct CustomContentUnavailableView: View {
    var imageName: String
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240, height: 240)
                    .cornerRadius(15.0)
                    .accessibilityHidden(true) // Hide the background image itself from accessibility

                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5).clipShape(Circle()))
                    .accessibilityLabel(Text("Create a new quiz"))
                    .accessibilityAddTraits(.isButton)
            }
            
            Text("VOQA")
                .font(.callout)
                .fontWeight(.black)
                .lineLimit(3, reservesSpace: false)
                .multilineTextAlignment(.center)
                .frame(width: 180)
                .padding(.horizontal, 8)
                .accessibilityAddTraits(.isHeader)
            
            Text("Create a new audio quiz")
                .font(.caption)
                .foregroundStyle(.secondary)
                .hAlign(.center)
                .accessibilityLabel(Text("Create a new audio quiz description"))
        }
        .padding(.bottom)
        .accessibilityElement(children: .combine) // Combine all elements into a single accessibility element
        .accessibilityLabel(Text("Create a new quiz section"))
    }
}


#Preview {
    CustomContentUnavailableView(imageName: "IconImage")
}
