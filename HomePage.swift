//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

struct HomePage: View {
    private var configManager = VoqaConfigManager()
    @State private var selectedTab = 0
    @State private var collections: [VoqaCollection] = []
    @State private var errorMessage: IdentifiableError?
    @State private var currentItem: Int = 0
    @State private var backgroundImage: String = ""
    @State private var path = NavigationPath()

    // State variables for different categories
    @State private var topPicks: [Voqa] = []
    @State private var certificationExams: [Voqa] = []
    @State private var stemSubjects: [Voqa] = []
    @State private var artsAndHumanities: [Voqa] = []
    @State private var professionalExams: [Voqa] = []
    @State private var others: [Voqa] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack(alignment: .topLeading) {
                    if let currentQuiz = topPicks[safe: currentItem] {
                        BackgroundView(backgroundImage: currentQuiz.imageUrl, color: Color.fromHex(currentQuiz.colors.main))
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            if !topPicks.isEmpty {
                                QuizCarouselView(quizzes: topPicks, currentItem: $currentItem, backgroundImage: $backgroundImage, tapAction: {
                                    path.append(topPicks[currentItem])
                                })
                            }

                            HorizontalQuizListView(quizzes: stemSubjects, title: "STEM Subjects", tapAction: { quiz in
                                path.append(quiz)
                            })

                            HorizontalQuizListView(quizzes: certificationExams, title: "Certification Exams", tapAction: { quiz in
                                path.append(quiz)
                            })

                            HorizontalQuizListView(quizzes: artsAndHumanities, title: "Arts and Humanities", subtitle: "Discover the History, Literature, Innovation of Cultures and Societies Worldwide", tapAction: { quiz in
                                path.append(quiz)
                            })

                            HorizontalQuizListView(quizzes: professionalExams, title: "Professional Exams", tapAction: { quiz in
                                path.append(quiz)
                            })
                            
                            HorizontalQuizListView(quizzes: others, title: "Others", tapAction: { quiz in
                                path.append(quiz)
                            })

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
                        //try await configManager.createTestDocument()
                        do {
                            collections = try await configManager.loadFromBundle(bundleFileName: "HomepageConfig")
                            assignCollections() // Assign collections based on category
                        } catch {
                            errorMessage = IdentifiableError(message: "Error loading collections: \(error)")
                            print(errorMessage?.message ?? "")
                        }
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

    private func assignCollections() {
        topPicks = collections.first(where: { $0.category == "Top Picks" })?.quizzes ?? []
        certificationExams = collections.first(where: { $0.category == "Certification Exams" })?.quizzes ?? []
        stemSubjects = collections.first(where: { $0.category == "STEM Subjects" })?.quizzes ?? []
        artsAndHumanities = collections.first(where: { $0.category == "Arts and Humanities" })?.quizzes ?? []
        professionalExams = collections.first(where: { $0.category == "Professional Exams" })?.quizzes ?? []
        others = collections.first(where: { $0.category == "Others" })?.quizzes ?? []
    }
}


#Preview {
    HomePage()
        .preferredColorScheme(.dark)
}


struct ProfileView: View {
    @StateObject private var viewModel = HomePageViewModel()
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

