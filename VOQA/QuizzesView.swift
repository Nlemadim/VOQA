//
//  QuizzesView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/16/24.
//

import SwiftUI
import Combine

// MARK: - QuizzesView
struct QuizzesView: View {
    @State private var selectedTab: QuizTab = .categories
    @State private var selectedCategory: Category? = nil
    @State private var showLockedAlert: Bool = false
    @State private var isLoadingQuestions: Bool = false
    
    
    var quizTopics: [String]
    
    var loadAction: (String) -> Void
    
    enum QuizTab: Int {
        case categories = 0
        case loading = 1
    }
    
    // Computed property to generate and sort categories from quizTopics
    var categories: [Category] {
        quizTopics.map { topicName in
            let isLocked = ["All Categories", "Learning Path", "Community Questions"].contains(topicName)
            let subtitle: String?
            if isLocked {
                subtitle = "Subscribe to Unlock"
            } else if isLoadingQuestions && selectedCategory?.name == topicName {
                subtitle = "Loading quiz questions..."
            } else {
                subtitle = nil
            }
            let icon = iconImage(topicName)
            return Category(name: topicName, subtitle: subtitle, isLocked: isLocked, iconName: icon)
        }
        .sorted {
            if $0.isLocked == $1.isLocked {
                return false // Maintain original order if both are locked or unlocked
            }
            return !$0.isLocked // Unlocked (false) comes before locked (true)
        }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Slide 1: Category Selection
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(categories) { category in
                                CategoryRow(
                                    category: category,
                                    isLoadingQuiz: selectedCategory?.id == category.id && selectedTab == .loading
                                ) {
                                    if category.isLocked {
                                        showLockedAlert = true
                                    } else {
                                        selectedCategory = category
                                        selectedTab = .loading
                                        isLoadingQuestions = true
                                        loadAction(category.name) // Initiate loading action
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    Spacer()
                }
                .tag(QuizTab.categories)
                .alert(isPresented: $showLockedAlert) {
                    Alert(
                        title: Text("Locked"),
                        message: Text("Please subscribe to unlock this feature."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                // Slide 2: Loading Quiz
                if let category = selectedCategory { // Renamed binding variable to 'category'
                    LoadingQuizView(category: category) {
                        selectedTab = .categories
                        selectedCategory = nil // Correctly assigns 'nil' to the outer 'selectedCategory'
                    }
                    .tag(QuizTab.loading)
                } 
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide page index
            .animation(.easeInOut, value: selectedTab)
            
            // Disable swipe gestures when in Loading tab
            if selectedTab == .loading {
                Color.clear
                    .contentShape(Rectangle())
                    .allowsHitTesting(true) // Captures all gestures, effectively disabling swipe
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Function to determine the icon name based on the topic name
    func iconImage(_ topicName: String) -> String {
        switch topicName {
        case "All Categories":
            return "list.bullet"
        case "Learning Path":
            return "map"
        case "Community Questions":
            return "person.3.fill"
        default:
            return "dot.scope" // Default icon for specific topics
        }
    }
}

#Preview {
    QuizzesView(quizTopics: ["Maths", "Physics", "Chemistry"], loadAction: { topicName in
        
    })
    .preferredColorScheme(.dark)
}

