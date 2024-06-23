//
//  HomePage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var connectionMonitor = NetworkMonitor.shared
    @ObservedObject var quizContext: QuizContext
    @StateObject private var generator = ColorGenerator()
    
    @State private var selectedQuizPackage: QuizPackageProtocol?
    
    var config: HomePageConfig
    
    init(config: HomePageConfig, quizContext: QuizContext) {
        self.config = config
        self.quizContext = quizContext
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                BackgroundView(backgroundImage: config.backgroundImage, color: .themeTeal) // You can replace .themeTeal with the appropriate color
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        MyCollectionView(
                            quizzes: config.topCollectionQuizzes,
                            currentItem: .constant(config.currentItem), generator: generator,
                            backgroundImage: .constant(config.backgroundImage),
                            tapAction: {
                                selectedQuizPackage = config.topCollectionQuizzes[config.currentItem]
                            }
                        )
                        
                        if let nowPlaying = config.nowPlaying {
                            NowPlayingView(
                                nowPlaying: nowPlaying, generator: generator,
                                questionCount: nowPlaying.currentQuizTopics.flatMap { $0.questions }.count,
                                currentQuestionIndex: 0,
                                color: Color.primary,
                                quizContext: quizContext,
                                isDownloading: .constant(false),
                                playAction: { print("Play action") }
                            )
                        }
                        
                        ForEach(config.galleryItems.indices, id: \.self) { index in
                            let item = config.galleryItems[index]
                            GalleryCollectionView(
                                quizzes: item.quizzes,
                                title: item.title,
                                subtitle: item.subtitle,
                                tapAction: { quiz in
                                    selectedQuizPackage = quiz
                                }
                            )
                        }
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 100)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
