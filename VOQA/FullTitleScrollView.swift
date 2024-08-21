//
//  FullTitleScrollView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import Foundation
import SwiftUI

// Define the FullTitlesScrollView model
struct FullTitlesScrollView: View {
    var collections: [VoqaCollection]
    var tapAction: () -> Void
    @Binding var selectedVoqa: Voqa?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(collections) { collection in
                    Section(header: VoqaCollectionHeaderView(category: collection.category, subtitle: collection.subtitle)) {
                        ForEach(collection.quizzes) { quiz in
                            FullTitleView(quiz: quiz, tapAction: { tapAction() })
                                
                        }
                    }
                }
            }
            .padding()
        }
        .background {
            HomePageBackground()
        }
    }
}

struct FullTitlesScrollViewV1: View {
    var collections: [VoqaCollection]
    var tapAction: (Voqa) -> Void
    @Binding var selectedVoqa: Voqa?
    @Binding var currentCategory: String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(collections) { collection in
                    Section(header: VoqaCollectionHeaderView(category: collection.category, subtitle: collection.subtitle)) {
                        ForEach(collection.quizzes) { quiz in
                            FullTitleView(quiz: quiz, tapAction: {
                                selectedVoqa = quiz
                            })
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        updateCurrentCategory(geo: geo, collection: collection)
                                    }
                                    .onChange(of: geo.frame(in: .global).minY) {_, _ in
                                        updateCurrentCategory(geo: geo, collection: collection)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .background {
            HomePageBackground()
        }
    }
    
    private func updateCurrentCategory(geo: GeometryProxy, collection: VoqaCollection) {
        DispatchQueue.main.async {
            if geo.frame(in: .global).minY < 100 && geo.frame(in: .global).maxY > 100 {
                currentCategory = collection.category
            }
        }
    }
}
