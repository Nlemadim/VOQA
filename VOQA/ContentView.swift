//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = false
    @AppStorage("load_catalogue") private var loadCatalogue: Bool = true
    @EnvironmentObject var user: User
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $navigationRouter.path) {
            VStack {
                if logStatus {
                    MainView(logStatus: logStatus)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            navigate(to: destination)
                        }
                } else {
                    AppLaunch(loadCatalogue: loadCatalogue)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            navigate(to: destination)
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await getCatalogue()
                }
            }
            .alert(item: $databaseManager.currentError) { error in
                Alert(
                    title: Text(error.title ?? "Error"),
                    message: Text(error.message ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func getCatalogue() async {
        DispatchQueue.main.async {
            loadCatalogue = true
        }
        
        guard databaseManager.quizCollection.isEmpty else {
            DispatchQueue.main.async {
                loadCatalogue = false
            }
            return
        }
        
        await databaseManager.fetchQuizCollection()
        
        DispatchQueue.main.async {
            loadCatalogue = false
        }
    }
    
    @ViewBuilder
    private func navigate(to destination: NavigationDestination) -> some View {
        switch destination {
        case .createAccount:
            CreateAccountView()
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        case .quizPlayer(let voqa):
            QuizDashboard(isLoggedIn: true, voqa: voqa)
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        case .mainView:
            MainView(logStatus: logStatus)
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        case .homePage:
            HomePage(quizCatalogue: databaseManager.quizCatalogue)
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        case .quizDetailPage(let voqa):
            QuizDetailPage(audioQuiz: voqa)
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        case .quizDashboard(let voqa):
            QuizDashboard(isLoggedIn: true, voqa: voqa)
                .environmentObject(navigationRouter)
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)
            
        }
    }
}

#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    let navMgr = NavigationRouter()
    let user = User()
    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
        .environmentObject(user)
        .environmentObject(navMgr)
}

/**
 
 if logStatus {
     BaseView {
         HomePage()
     }
 } else {
     AppLaunch()
 
 
 {
   "category": "Others",
   "subtitle": "Discover a diverse range of quizzes that don't fit the typical mold. Perfect for expanding your knowledge across various fields.",
   "quizzes": [
     {
       "name": "Mega Structures of America",
       "acronym": "Mega Structures",
       "about": "Explore the architectural marvels and engineering feats of America's mega structures through this quiz.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/MegaStructuresOfAmerica/Mega Structures of America.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Engineering and Architecture", "History"],  // Updated
       "colors": {
         "main": "#2C3E50",
         "sub": "#2980B9",
         "third": "#34495E"
       }
     },
     {
       "name": "Black American History",
       "acronym": "Black History",
       "about": "Delve into the rich and complex history of Black Americans, their struggles, achievements, and cultural impact.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/blackAmericanHistory/Black American History.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["History", "Cultural Studies"],  // Updated
       "colors": {
         "main": "#EAE4CF",
         "sub": "#DA951D",
         "third": "#111011"
       }
     },
     {
       "name": "World War II History",
       "acronym": "WWII",
       "about": "Study the pivotal events, key figures, and global impact of World War II through this engaging quiz.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/WorldWar2/WorldWar2.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["History", "War"],  // Updated
       "colors": {
         "main": "#8E44AD",
         "sub": "#9B59B6",
         "third": "#34495E"
       }
     },
     {
       "name": "MLB G.O.A.T",
       "acronym": "MLB",
       "about": "Test your knowledge on the greatest of all time in Major League Baseball history.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/advancedPlacement/AdvancedPlacementExam.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Sports", "Baseball"],  // Updated
       "colors": {
         "main": "#1F618D",
         "sub": "#2980B9",
         "third": "#34495E"
       }
     },
     {
       "name": "NBA G.O.A.T",
       "acronym": "NBA",
       "about": "Discover the legendary players in NBA history with quizzes on the greatest of all time.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/advancedPlacement/AdvancedPlacementExam.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Sports", "Basketball"],  // Updated
       "colors": {
         "main": "#F39C12",
         "sub": "#E67E22",
         "third": "#D35400"
       }
     },
     {
       "name": "ACT",
       "acronym": "ACT",
       "about": "Prepare for the ACT with quizzes on English, Math, Reading, and Science reasoning skills.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/act/ACT-Test.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Education and Tests", "Standardized Test"],  // Updated
       "colors": {
         "main": "#FAF8D9",
         "sub": "#FCB007",
         "third": "#040F41"
       }
     },
     {
       "name": "Kotlin Programming Language",
       "acronym": "Kotlin",
       "about": "Learn the essentials of Kotlin, from syntax and functions to object-oriented and functional programming features.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/kotlin/Kotlin Programming Language.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Programming"],  // Updated
       "colors": {
         "main": "#2980B9",
         "sub": "#3498DB",
         "third": "#34495E"
       }
     },
     {
       "name": "Swift Programming Language",
       "acronym": "Swift",
       "about": "Understand the core concepts of Swift, including syntax, data types, and iOS app development techniques.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/swift/Swift Programming Language.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Programming"],  // Updated
       "colors": {
         "main": "#FAE79E",
         "sub": "#D74924",
         "third": "#A82125"
       }
     },
     {
       "name": "Data Science and Analytics",
       "acronym": "Data Science",
       "about": "Explore data science techniques and analytics processes, from data cleaning to advanced machine learning applications.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/DataScienceAnalytics/Data-Science-Analytics Medium.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Data Science"],  // Updated
       "colors": {
         "main": "#6FA6BF",
         "sub": "#4E5B7A",
         "third": "#4A87A2"
       }
     },
     {
       "name": "Privacy Engineering",
       "acronym": "Privacy",
       "about": "Understand the principles of privacy engineering, including data protection and user privacy in digital systems.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/PrivacyEngineering/Privacy_Engineering Large.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Privacy"],  // Updated
       "colors": {
         "main": "#2C5684",
         "sub": "#4379AA",
         "third": "#82CCE8"
       }
     },
     {
       "name": "TOEFL",
       "acronym": "TOEFL",
       "about": "Prepare for the TOEFL exam with quizzes on English language skills, including reading, writing, listening, and speaking.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/Toefel/TOFEL.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Education and Tests", "Test Prep"],  // Updated
       "colors": {
         "main": "#D4C5A7",
         "sub": "#A2CCC4",
         "third": "#467E90"
       }
     },
     {
       "name": "SAP",
       "acronym": "SAP",
       "about": "Test your knowledge of SAP software and its applications in business processes with this comprehensive quiz.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/Sap/SAP-Exam.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Business"],  // Updated
       "colors": {
         "main": "#607B8B",
         "sub": "#405868",
         "third": "#8E9DA2"
       }
     },
     {
       "name": "UI & UX Design",
       "acronym": "UI/UX",
       "about": "Explore the fundamentals of UI and UX design, including principles of user-centered design and usability testing.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/UiUxDesign/UI and UX Design.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Design", "UI/UX"],  // Updated
       "colors": {
         "main": "#1B5B8F",
         "sub": "#A92006",
         "third": "#347F95"
       }
     },
     {
       "name": "Microsoft Azure",
       "acronym": "Azure",
       "about": "Understand cloud computing services and infrastructure with quizzes on Microsoft Azure's key features and capabilities.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/microsoftAzure/Microsoft Azure.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["Tech and Innovation", "Cloud Computing"],  // Updated
       "colors": {
         "main": "#587B97",
         "sub": "#355973",
         "third": "#8BCAE4"
       }
     },
     {
       "name": "World War I History",
       "acronym": "WWI",
       "about": "Explore the key events, battles, and figures of World War I with this in-depth historical quiz.",
       "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/WorldWar1/WorldWar1.png",
       "rating": 0,
       "curator": "",
       "users": 0,
       "categories": ["History", "War"],  // Updated
       "colors": {
         "main": "#F3EDD1",
         "sub": "#8A7050",
         "third": "#6A5234"
       }
     }
   ]
 }

 
 
 
 }
 */



