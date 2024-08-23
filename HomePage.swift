//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 0
    @State private var errorMessage: IdentifiableError?
    @State private var currentItem: Int = 0
    @State private var backgroundImage: String = ""
    @State private var path = NavigationPath()

    // Replace individual category state variables with a single catalogue
    var quizCatalogue: [QuizCatalogue]

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack(alignment: .topLeading) {
                    if let currentQuiz = quizCatalogue.first(where: { $0.categoryName == "Top Picks" })?.quizzes[safe: currentItem] {
                        BackgroundView(backgroundImage: currentQuiz.imageUrl, color: Color.fromHex(currentQuiz.colors.main))
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            if let topPicks = quizCatalogue.first(where: { $0.categoryName == "Top Picks" })?.quizzes, !topPicks.isEmpty {
                                QuizCarouselView(quizzes: topPicks, currentItem: $currentItem, backgroundImage: $backgroundImage, tapAction: {
                                    path.append(topPicks[currentItem])
                                })
                            }

                            // Dynamic creation of HorizontalQuizListViews based on quizCatalogue
                            ForEach(quizCatalogue, id: \.categoryName) { category in
                                HorizontalQuizListView(quizzes: category.quizzes, title: category.categoryName, subtitle: nil, tapAction: { quiz in
                                    path.append(quiz)
                                })
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
                .onAppear {
                    Task {
                        // Handle any onAppear logic if needed
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
                TabIcons(title: "Home", icon: "square.grid.2x2")
            }
            .tag(0)

            ProfileView()
                .tabItem {
                    TabIcons(title: "Performance", icon: "chart.bar.fill")
                }
                .tag(1)

            PerformanceView()
                .tabItem {
                    TabIcons(title: "Profile", icon: "person.fill")
                }
                .tag(2)
        }
        .tint(.white).activeGlow(.white, radius: 2)
    }
}


//#Preview {
//    HomePage()
//        .preferredColorScheme(.dark)
//}


struct ProfileView: View {
    @State private var voqaItem: Voqa?
    @State private var path = NavigationPath()
    @State private var currentQuiz = [Voqa]()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Placeholder Profile View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
//                HorizontalQuizListView(quizzes: currentQuiz, title: "STEM Subjects", tapAction: { quiz in
//                    path.append(quiz)
//                })
            }
            .onAppear {
                getCatalogue()
            }
        }
    }
    
    func getCatalogue()  {
        Task {
           // viewModel.updateVoqaCatalogue()
            
        }
    }
}

