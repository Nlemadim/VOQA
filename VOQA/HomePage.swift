//
//  HomePage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI
import SwiftData

struct HomePage: View {
    @ObservedObject var connectionMonitor = NetworkMonitor.shared
    @StateObject var quizContext: QuizContext
    @StateObject private var generator = ColorGenerator()
    @StateObject var keyboardObserver = KeyboardObserver()
    
    @State private var selectedPacketCover: PacketCover?
    @State private var selectedTab: Int = 0
    @State var didTapEdit = false
    @State var expandSheet = false
    
    var config: HomePageConfig
    
    init(config: HomePageConfig) {
        let context = QuizContext.create(state: IdleState())
        _quizContext = StateObject(wrappedValue: context)
        self.config = config
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ZStack(alignment: .topLeading) {
                    BackgroundView(backgroundImage: config.backgroundImage, color: generator.dominantBackgroundColor)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            MyCollectionView(
                                quizzes: config.topCollectionQuizzes,
                                currentItem: .constant(config.currentItem),
                                generator: generator,
                                backgroundImage: .constant(config.backgroundImage),
                                tapAction: {
                                    let selected = config.topCollectionQuizzes[config.currentItem]
                                    selectedPacketCover = selected
                                }
                            )
                            
                            ForEach(config.galleryItems, id: \.self) { package in
                                GalleryCollectionView(
                                    quizzes: config.galleryItems,
                                    title: package.title,
                                    subtitle: package.edition, // Use appropriate property
                                    tapAction: { package in
                                        selectedPacketCover = package
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
                .fullScreenCover(item: $selectedPacketCover) { selectedQuiz in
                    QuizDetailPage(package: selectedQuiz, selectedTab: $selectedTab)
                }
                .onAppear {
                    generator.updateAllColors(fromImageNamed: config.backgroundImage)
                }
                .tabItem {
                    TabIcons(title: "Home", icon: "house.fill")
                }
                .tag(0)
                
                QuizPlayerPage(selectedTab: $selectedTab, config: config)
                    .tabItem {
                        TabIcons(title: "Quiz player", icon: "play.circle")
                    }
                    .tag(1)
                
                ExplorePage(selectedTab: $selectedTab)
                    .tabItem {
                        TabIcons(title: "Browse", icon: "square.grid.2x2")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        TabIcons(title: "My Library", icon: "books.vertical.fill")
                    }
                    .tag(3)
            }
            .tint(.white).activeGlow(.white, radius: 2)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("VOQA")
                        .font(.title)
                        .fontWeight(.black)
                        .kerning(-0.5)
                        .primaryTextStyleForeground()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20.0)
                }
            }
            .onAppear {
                customizeTabBarAppearance()
            }
        }
    }
    
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


struct ProfileView: View {
   
    var body: some View {
        // HomePage implementation
        Text("Home Page") // Placeholder
    }
}





//struct HomePage: View {
//    @ObservedObject var connectionMonitor = NetworkMonitor.shared
//    @ObservedObject var quizContext: QuizContext
//    @StateObject private var generator = ColorGenerator()
//    @StateObject var keyboardObserver = KeyboardObserver()
//    
//    @State private var selectedQuizPackage: QuizPackageType?
//    @State private var selectedTab: Int = 0
//    @State var didTapEdit = false
//    @State var expandSheet = false
//    
//    var config: HomePageConfig
//    
//    var body: some View {
//        NavigationView {
//            TabView(selection: $selectedTab) {
//                ZStack(alignment: .topLeading) {
//                    BackgroundView(backgroundImage: config.backgroundImage, color: generator.dominantBackgroundColor)
//                    
//                    ScrollView(showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 0) {
//                            MyCollectionView(
//                                quizzes: config.topCollectionQuizzes,
//                                currentItem: .constant(config.currentItem),
//                                generator: generator,
//                                backgroundImage: .constant(config.backgroundImage),
//                                tapAction: {
//                                    let selected = config.topCollectionQuizzes[config.currentItem]
//                                    if let standardPackage = selected as? StandardQuizPackage {
//                                        selectedQuizPackage = .standard(standardPackage)
//                                    } else if let customPackage = selected as? CustomQuizPackage {
//                                        selectedQuizPackage = .custom(customPackage)
//                                    }
//                                }
//                            )
//                            
//                            ForEach(config.galleryItems.indices, id: \.self) { index in
//                                let item = config.galleryItems[index]
//                                GalleryCollectionView(
//                                    quizzes: item.quizzes,
//                                    title: item.title,
//                                    subtitle: item.subtitle,
//                                    tapAction: { quiz in
//                                        if let standardPackage = quiz as? StandardQuizPackage {
//                                            selectedQuizPackage = .standard(standardPackage)
//                                        } else if let customPackage = quiz as? CustomQuizPackage {
//                                            selectedQuizPackage = .custom(customPackage)
//                                        }
//                                    }
//                                )
//                            }
//                            
//                            Rectangle()
//                                .fill(.clear)
//                                .frame(height: 100)
//                        }
//                    }
//                    .zIndex(1)
//                }
//                .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
//                    QuizDetailPage(package: selectedQuiz.wrapped, selectedTab: $selectedTab)
//                }
//                
//                .onAppear {
//                    generator.updateAllColors(fromImageNamed: config.backgroundImage)
//                }
//                .tabItem {
//                    TabIcons(title: "Home", icon: "house.fill")
//                }
//                .tag(0)
//                
//                QuizPlayerPage(quizContext: quizContext, selectedTab: $selectedTab, config: config)
//                    .tabItem {
//                        TabIcons(title: "Quiz player", icon: "play.circle")
//                    }
//                    .tag(1)
//                
//                ExploreView()
//                    .tabItem {
//                        TabIcons(title: "Browse", icon: "square.grid.2x2")
//                    }
//                    .tag(2)
//                
//                ProfileView()
//                    .tabItem {
//                        TabIcons(title: "My Library", icon: "books.vertical.fill")
//                    }
//                    .tag(3)
//            }
//            .tint(.white).activeGlow(.white, radius: 2)
//
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Text("VOQA")
//                        .font(.title)
//                        .fontWeight(.black)
//                        .kerning(-0.5)
//                        .primaryTextStyleForeground()
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Image(systemName: "person.circle")
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20.0)
//                }
//            }
//            .onAppear {
//                customizeTabBarAppearance()
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func BottomMiniPlayer(color: Color) -> some View {
//        
//        ZStack {
//            Rectangle()
//                .fill(.clear)
//                .cornerRadius(10)
//                .background(LinearGradient(gradient: Gradient(colors: [color, .black, .black]), startPoint: .top, endPoint: .bottom))
//                .overlay {
//                    MiniPlayer(refreshQuiz: .constant(false), expandSheet: $expandSheet)
//                        .padding(.bottom)
//                }
//        }
//        .overlay(alignment: .bottom, content: {
//            Rectangle()
//                .fill(.teal.opacity(0.3))
//                .frame(height: 1)
//                .offset(y: -3)
//        })
//        .frame(height: 75)
//        .offset(y: -49)
//    }
//
//    
//    private func customizeTabBarAppearance() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.black
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
//}



