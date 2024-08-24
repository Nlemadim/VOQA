//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 0
    @State private var errorMessage: IdentifiableError?
    @State private var currentItem: Int = 0
    @State private var backgroundImage: String = ""
    @State private var path = NavigationPath()

    var quizCatalogue: [QuizCatalogue]

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack(alignment: .topLeading) {
                    if let currentQuiz = quizCatalogue.first(where: { $0.categoryName == CatalogueDetails.topPicks().details.title })?.quizzes[safe: currentItem] {
                        BackgroundView(backgroundImage: currentQuiz.imageUrl, color: Color.fromHex(currentQuiz.colors.main))
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            if let topPicks = quizCatalogue.first(where: { $0.categoryName == CatalogueDetails.topPicks().details.title })?.quizzes, !topPicks.isEmpty {
                                QuizCarouselView(quizzes: topPicks, currentItem: $currentItem, backgroundImage: $backgroundImage, tapAction: {
                                    path.append(topPicks[currentItem])
                                })
                            }

                            // Dynamic creation of HorizontalQuizListViews based on quizCatalogue
                            ForEach(quizCatalogue, id: \.categoryName) { category in
                                HorizontalQuizListView(
                                    catalogue: category,
                                    tapAction: { quiz in
                                        path.append(quiz)
                                    }
                                )
                            }

                            Rectangle()
                                .fill(.clear)
                                .frame(height: 100)
                        }
                    }
                    .zIndex(1)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Text("VOQA")
                            .font(.title)
                            .fontWeight(.black)
                            .kerning(-0.5)
                            .primaryTextStyleForeground()
                    }
                }
                .alert(item: $errorMessage) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(for: Voqa.self) { voqa in
                    QuizDetailPage(audioQuiz: voqa)
                }
            }
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)

            MyLibrary()
                .tabItem {
                    TabIcons(title: "My Library", icon: "books.vertical.fill")
                }
                .tag(1)

            AudioSettings()
                .tabItem {
                    TabIcons(title: "Audio Settings", icon: "slider.horizontal.3")
                }
                .tag(2)

        }
        .tint(.white).activeGlow(.white, radius: 2)
    }
}


struct AudioSettings: View {
    var body: some View {
        VStack {
            Text("Audio Settings")
            
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Placeholder Profile View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
    }
}

