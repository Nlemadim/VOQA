//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var selectedTab = 0
    @State private var errorMessage: IdentifiableError?
    @State private var currentItem: Int = 0
    @State private var backgroundImage: String = ""
    @State private var hideTabBar: Bool = false
    @State private var isLoading: Bool = true

    var quizCatalogue: [QuizCatalogue]

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack(alignment: .topLeading) {
                    // Background based on the selected top picks quiz
                    if let currentQuiz = quizCatalogue.first(where: { $0.categoryName == CatalogueDetails.topPicks().details.title })?.quizzes[safe: currentItem] {
                        BackgroundView(backgroundImage: currentQuiz.imageUrl, color: Color.fromHex(currentQuiz.colors.main))
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            // Top Picks Carousel
                            if let topPicks = quizCatalogue.first(where: { $0.categoryName == CatalogueDetails.topPicks().details.title })?.quizzes, !topPicks.isEmpty {
                                QuizCarouselView(quizzes: topPicks, currentItem: $currentItem, backgroundImage: $backgroundImage) {
                                    navigationRouter.navigate(to: .quizDetailPage(topPicks[currentItem]))
                                }
                            }

                            // Display categories in the preferred order
                            createCategoryView(for: .educationAndTesting())   // Education
                            createCategoryView(for: .sportsAndRecreation())   // Sports
                            createCategoryView(for: .technologyAndInnovation())  // Technology
                            createCategoryView(for: .certificationsAndExams())
                            createCategoryView(for: .healthAndMedical())   // Medical
                            createCategoryView(for: .businessAndFinance())  // Business
                            
                            // Bottom spacing
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 100)
                        }
                    }
                }
                .toolbar(hideTabBar ? .hidden : .visible, for: .tabBar)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Text("VOQA")
                            .font(.title)
                            .fontWeight(.black)
                            .kerning(-0.5)
                            .foregroundColor(.primary) // Adjust as needed
                    }
                }
                .alert(item: $errorMessage) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .onAppear {
                    loadData()
                }
            }
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)

            MyChannels(hideTabBar: $hideTabBar, user: user)
                .tabItem {
                    TabIcons(title: "My Channels", icon: "sparkles.tv.fill")
                }
                .tag(1)

            AddOnsView(user: user, databaseManager: databaseManager)
                .tabItem {
                    TabIcons(title: "Add Ons", icon: "medal.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    TabIcons(title: "My Profile", icon: "person.fill")
                }
                .tag(3)
        }
        .tint(.white).activeGlow(.white, radius: 2)
    }
    
    private func loadData() {
        // Simulate data fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Update isLoading to false after data is fetched
            isLoading = false
        }
    }

    private func createCategoryView(for category: CatalogueDetails) -> some View {
        if let quizzes = quizCatalogue.first(where: { $0.categoryName == category.details.title })?.quizzes, !quizzes.isEmpty {
            return AnyView(
                HorizontalQuizListView(catalogue:
                                        QuizCatalogue(
                                            categoryName: category.details.title,
                                            description: category.details.description,
                                            quizzes: quizzes)) { quiz in
                                                navigationRouter.navigate(to: .quizDetailPage(quiz))
                                            }
            )
        } else {
            print("Missing category: \(category.details.title)")
            return AnyView(missingCategoryView(for: category))
        }
    }
    
    private func missingCategoryView(for category: CatalogueDetails) -> some View {
        VStack {
            Text("No quizzes available for \(category.details.title)")
                .font(.headline)
                .padding()
            Rectangle()
                .fill(Color.red.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    Text("Missing \(category.details.title)")
                        .foregroundColor(.red)
                )
        }
        .padding(.horizontal)
    }
}



struct AudioSettings: View {
    var body: some View {
        VStack {
            Text("Audio Settings")
            
        }
    }
}

//// Use medal.fill for badgess
//struct ProfileView: View {
//    //Theme colors: .mint, .purple, .teal. randomize for rectangle coolors, .
//    //Modularize and optimize the view to make it clean
//    // make a scroll view for when content is added
//    @EnvironmentObject var user: User
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            // Profile Information Section
//            HStack(alignment: .center, spacing: 16) {
//                if let profileImage = user.profileImage {
//                    Image(uiImage: profileImage)
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                } else {
//                    Image(systemName: "person.crop.circle.fill")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.teal)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.teal, lineWidth: 2))
//                }
//
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(user.fullName.isEmpty ? "Full Name" : user.fullName)
//                        .font(.title3)
//                        .fontWeight(.bold)
//                    Text("Account Type: \(AccountType.beta.rawValue) Subscriber")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text("Subscribed Quizzes: \(user.voqaCollection.count)")
//                        .font(.subheadline)
//                }
//            }
//            .padding(.top)
//
//            // Subscription Accesses Section
//            Text("Subscription Accesses:")
//                .font(.headline)
//                .padding(.top)
//
//            // Access Items Grid (Placeholder as User class does not have accessItems)
//            LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 10), count: 3), spacing: 10) {
//                ForEach(user.voqaCollection.map { $0.quizTitle }, id: \.self) { item in // Using voqaCollection titles as placeholder
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.blue)
//                            .frame(width: 100, height: 80)
//                            .cornerRadius(10)
//
//                        Text(item)
//                            .font(.subheadline)
//                            .foregroundColor(.white)
//                            
//                    }
//                }
//            }
//
//            // Badges Section (Placeholder since User class does not have badges)
//            VStack(alignment: .center) {
//                Text("Badges")
//                    .font(.headline)
//                    .padding(.top)
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//                Image(systemName: "star.circle")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.yellow)
//                    .padding(.bottom, 10)
//
//                // Placeholder badge scroll view
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 16) {
//                        ForEach(0..<5) { _ in // Placeholder loop
//                            VStack {
//                                Image(systemName: "seal")
//                                    .resizable()
//                                    .frame(width: 60, height: 60)
//                                    .foregroundColor(.purple)
//                                Text("Early Access Badge")
//                                    .font(.caption)
//                            }
//                        }
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//
//            // FAQs Section
//            DisclosureGroup("FAQs") {
//                VStack(alignment: .leading) {
//                    Text("Question 1: ...")
//                    Text("Question 2: ...")
//                }
//                .padding(.leading)
//            }
//            .padding(.top)
//
//            // Turn Off Mic Switcher (Placeholder, functionality not present in User class)
//            Toggle(isOn: .constant(true)) { // Placeholder binding
//                Text("Turn Off Mic")
//            }
//            .padding(.top)
//
//            // Delete Account Button
//            Button(action: {
//                user.clearCredentials() // Using the clearCredentials method
//            }) {
//                Text("Delete My Account")
//                    .foregroundColor(.red)
//            }
//            .padding(.top)
//
//            // Logout Button use: rectangle.portrait.and.arrow.right reduce red opacity
//            Button(action: {
//                user.isLoggedIn = false // Placeholder for logout functionality
//            }) {
//                HStack {
//                    Image(systemName: "arrow.backward.square")
//                    Text("Logout")
//                        .fontWeight(.bold)
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top)
//        }
//        .padding()
//    }
//}
