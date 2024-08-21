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

//struct HomePage: View {
//    @StateObject private var configManager = VoqaConfigManager()
//    @StateObject private var databaseManager = DatabaseManager.shared
//    @State private var selectedTab = 0
//    @State private var collections: [VoqaCollection] = []
//    @State private var errorMessage: IdentifiableError?
//    @State private var selectedVoqa: Voqa?
//    @State private var currentCategory: String = "VOQA"
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            NavigationStack {
//                FullTitlesScrollViewV1(collections: collections, tapAction: { quiz in
//                    selectedVoqa = quiz
//                }, selectedVoqa: $selectedVoqa, currentCategory: $currentCategory)
//                .zIndex(1)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text(currentCategory)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .kerning(-0.5)
//                            .foregroundStyle(.primary)
//                    }
//                    
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        NavigationLink(destination: Text("Search")) {
//                            Image(systemName: "magnifyingglass")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundStyle(.primary)
//                        }
//                    }
//                }
//                .onAppear {
//                    Task {
//                        do {
//                            collections = try await configManager.loadFromBundle(bundleFileName: "HomepageConfig")
//                        } catch {
//                            errorMessage = IdentifiableError(message: "Error loading collections: \(error)")
//                            print(errorMessage?.message ?? "")
//                        }
//                    }
//                }
//                .alert(item: $errorMessage) { error in
//                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
//                }
//                .fullScreenCover(item: $selectedVoqa) { voqa in
//                    QuizInfoView(selectedVoqa: voqa)
//                }
//            }
//            .tabItem {
//                TabIcons(title: "Home", icon: "square.grid.2x2")
//            }
//            .tag(0)
//            
//            PerformanceView()
//                .tabItem {
//                    TabIcons(title: "Performance", icon: "chart.bar.fill")
//                }
//                .tag(1)
//            
//            
//            ProfileView()
//                .tabItem {
//                    TabIcons(title: "Profile", icon: "person.fill")
//                }
//                .tag(2)
//                .tint(.white).activeGlow(.white, radius: 2)
//        }
//        .tint(.white).activeGlow(.white, radius: 2)
//    }
//}


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
            viewModel.updateVoqaCatalogue()
            
        }
    }
}


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


struct HorizontalQuizListView: View {
    var quizzes: [Voqa]
    var title: String
    var subtitle: String?
    let tapAction: (Voqa) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5) // Reduces the default spacing between characters
                .padding(.horizontal)
                .lineLimit(1) // Ensures the text does not wrap
                .truncationMode(.tail) // Adds "..." at the end if the text is too long
                .frame(maxWidth: .infinity, alignment: .leading)

            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(quizzes, id: \.self) { quiz in
                        ImageAndTitleView(title: quiz.acronym, titleImage: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}


struct BackgroundView: View {
    var backgroundImage: String
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 300)
            .background(
                LinearGradient(gradient: Gradient(colors: [color, color, .black]), startPoint: .top, endPoint: .bottom)
            )
            .overlay {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(height: 300)
            .blur(radius: 100)
    }
}

