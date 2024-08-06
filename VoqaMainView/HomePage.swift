//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var configManager = VoqaConfigManager()
    @StateObject private var databaseManager = DatabaseManager.shared
    @State private var selectedTab = 0
    @State private var collections: [VoqaCollection] = []
    @State private var errorMessage: IdentifiableError?
    @State private var selectedVoqa: Voqa?
    @State private var currentCategory: String = "VOQA"

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                FullTitlesScrollViewV1(collections: collections, tapAction: { quiz in
                    selectedVoqa = quiz
                }, selectedVoqa: $selectedVoqa, currentCategory: $currentCategory)
                .zIndex(1)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(currentCategory)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .kerning(-0.5)
                            .foregroundStyle(.primary)
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Text("Search")) {
                            Image(systemName: "magnifyingglass")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .onAppear {
                    Task {
                        do {
                            collections = try await configManager.loadFromBundle(bundleFileName: "HomepageConfig")
                        } catch {
                            errorMessage = IdentifiableError(message: "Error loading collections: \(error)")
                            print(errorMessage?.message ?? "")
                        }
                    }
                }
                .alert(item: $errorMessage) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .fullScreenCover(item: $selectedVoqa) { voqa in
                    QuizInfoView(selectedVoqa: voqa)
                }
            }
            .tabItem {
                TabIcons(title: "Home", icon: "square.grid.2x2")
            }
            .tag(0)
            
            PerformanceView()
                .tabItem {
                    TabIcons(title: "Performance", icon: "chart.bar.fill")
                }
                .tag(1)
            
            
            ProfileView()
                .tabItem {
                    TabIcons(title: "Profile", icon: "person.fill")
                }
                .tag(2)
                .tint(.white).activeGlow(.white, radius: 2)
        }
        .tint(.white).activeGlow(.white, radius: 2)
    }
}


#Preview {
    HomePage()
        .preferredColorScheme(.dark)
}




struct ProfileView: View {
    var body: some View {
        Text("Placeholder Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}







/**
 
 struct QuizCarouselView: View {
     var quizzes: [AudioQuizPackage]
     @Binding var currentItem: Int
     @ObservedObject var generator: ColorGenerator
     @Binding var backgroundImage: String
     let tapAction: () -> Void
     
     var body: some View {
         Text("Top Picks")
             .font(.headline)
             .fontWeight(.bold)
             .padding(.horizontal)
             .hAlign(.leading)
         
         TabView(selection: $currentItem) {
             ForEach(quizzes.indices, id: \.self) { index in
                 let quiz = quizzes[index]
                 VStack(spacing: 4) {
                     Image(quiz.imageUrl)
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: 240, height: 240)
                         .cornerRadius(15.0)
                     
                     Text(quiz.acronym)
                         .font(.callout)
                         .fontWeight(.black)
                         .lineLimit(3, reservesSpace: false)
                         .multilineTextAlignment(.center)
                         .frame(width: 180)
                         .padding(.horizontal, 8)
                        // .padding(.bottom)
                     
                     Text(quiz.version.descr)
                         .font(.caption)
                         .foregroundStyle(.secondary)
                         .hAlign(.center)
                     
                     if let curator = quiz.curator {
                         Text("Curated by: " + curator)
                             .font(.caption)
                             .foregroundStyle(.secondary)
                             .hAlign(.center)
                     }
                     
                     if let users = quiz.users {
                         Text("Users: \(users)")
                             .font(.caption)
                             .foregroundStyle(.secondary)
                             .hAlign(.center)
                     }
                     
                     if let rating = quiz.rating {
                         HStack {
                             ForEach(1...5, id: \.self) { index in
                                 if index <= rating {
                                     Image(systemName: "star.fill")
                                         .imageScale(.small)
                                         .foregroundStyle(.yellow)
                                 } else {
                                     Image(systemName: "star")
                                         .imageScale(.small)
                                         .foregroundStyle(.secondary)
                                 }
                             }
                         }
                     }
                 }
                 .padding(.bottom)
                 .onTapGesture {
                     tapAction()
                 }
                 .onAppear {
                     generator.updateAllColors(fromImageNamed: quiz.imageUrl)
                     backgroundImage = quiz.imageUrl // Update background
                 }
             }
         }
         .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
         .frame(height: 400)
     }
 }

 
 TabView(selection: $selectedTab) {
     NavigationStack(path: $path) {
         ZStack(alignment: .topLeading) {
             BackgroundView(backgroundImage: backgroundImage, color: generator.dominantBackgroundColor)
             
             ScrollView(showsIndicators: false) {
                 VStack(alignment: .leading, spacing: 0) {
                     QuizCarouselView(quizzes: topCollectionQuizzes, currentItem: $currentItem, generator: generator, backgroundImage: $backgroundImage, tapAction: {
                         selectedQuizPackage = topCollectionQuizzes[currentItem]
                     })
                     
                     HorizontalQuizListView(quizzes: topColledgeCollection, title: "Most popular in the U.S", tapAction: { quiz in
                         selectedQuizPackage = quiz
                        
                     })
                     
                     HorizontalQuizListView(quizzes: topProCollection, title: "Top Professional Certifications", tapAction: { quiz in
                         selectedQuizPackage = quiz
                         
                     })
                     
                     HorizontalQuizListView(quizzes: cultureAndSociety, title: "Culture And Society", subtitle: "Discover the History, Literature, Innovation of Cultures and Societies Worldwide", tapAction: { quiz in
                         selectedQuizPackage = quiz
                     })
                     
                     Rectangle()
                         .fill(.clear)
                         .frame(height: 100)
                 }
 
 
 
 
 struct HorizontalQuizListView: View {
     var quizzes: [AudioQuizPackage]
     var title: String
     var subtitle: String?
     let tapAction: (AudioQuizPackage) -> Void

     var body: some View {
         VStack(spacing: 4.0) {
             Text(title.uppercased())
                 .font(.subheadline)
                 .fontWeight(.bold)
                 .kerning(-0.5) // Reduces the default spacing between characters
                 .padding(.horizontal)
                 .lineLimit(1) // Ensures the text does not wrap
                 .truncationMode(.tail) // Adds "..." at the end if the text is too long
                 .hAlign(.leading)
                        
             if let subtitle {
                 Text(subtitle)
                     .font(.footnote)
                     .padding(.horizontal)
                     .hAlign(.leading)
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

 QUIZ DETAIL PAGE
 NavigationView {
     ZStack(alignment: .topLeading) {
         Rectangle()
             .fill(.clear)
             .background(
                 LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
             )
         
         VStack(alignment: .center) {
             Image(audioQuiz.imageUrl)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .clipped()
         }
         .frame(height: 280)
         .blur(radius: 60)
         
         ScrollView(showsIndicators: false) {
             VStack(alignment: .leading, spacing: 10) {
                 VStack(spacing: 5) {
                     Image(audioQuiz.imageUrl)
                         .resizable()
                         .frame(width: 250, height: 250)
                         .cornerRadius(20)
                         .padding()
                     
                     Text(audioQuiz.name)
                         .lineLimit(4, reservesSpace: false)
                         .multilineTextAlignment(.center)
                         .fontWeight(.bold)
                         .foregroundStyle(.primary)
                         .frame(maxWidth: .infinity)
                         .hAlign(.center)
                     
                     Text(audioQuiz.version.descr)
                         .font(.caption)
                         .foregroundStyle(.secondary)
                         .hAlign(.center)
                     
                     if let curator = audioQuiz.curator {
                         Text("Curated by: " + curator)
                             .font(.caption)
                             .foregroundStyle(.secondary)
                             .hAlign(.center)
                     }
                     
                     if let users = audioQuiz.users {
                         Text("Users: \(users)")
                             .font(.caption)
                             .foregroundStyle(.secondary)
                             .hAlign(.center)
                     }
                     
                     if let rating = audioQuiz.rating {
                         HStack {
                             ForEach(1...5, id: \.self) { index in
                                 if index <= rating {
                                     Image(systemName: "star.fill")
                                         .imageScale(.small)
                                         .foregroundStyle(.yellow)
                                 } else {
                                     Image(systemName: "star")
                                         .imageScale(.small)
                                         .foregroundStyle(.yellow)
                                 }
                             }
                         }
                     }
                 }
                 //.frame(height: 300)
                 .frame(maxWidth:.infinity)
                 .padding()
                 .hAlign(.center)
                 
                 
                 VStack(alignment: .leading) {
                     
                     PlaySampleButton(interactionState: .constant(sampleButtonInteraction()), playAction: { fetchOrPlaySample() })
                         .padding(.horizontal)
                         .padding()
                         .padding(.top)
                         .hAlign(.center)
                     
                     PlainClearButton(color: interactionState == .isDownloading ? generator.dominantBackgroundColor.opacity(0.4) : generator.dominantBackgroundColor, label: !hasFullVersion ? downloadButtonLabel : "Start Quiz") {
                         goToFullVersion()
                     }
                     .disabled(interactionState == .isDownloading)
                     .padding(.horizontal)
                     .padding(5)
                     
                 }
                 .padding(.horizontal)
                 .offset(y: -40)
                 
                 VStack {
                     
                     Text("Category")
                         .fontWeight(.bold)
                         .foregroundStyle(.primary)
                         .hAlign(.leading)
                     
                     HStack(spacing: 16.0) {
                         ForEach(audioQuiz.category, id: \.self) { category in
                             Text(category.descr)
                                 .font(.system(size: 10))
                                 .fontWeight(.light)
                                 .lineLimit(1)
                                 .padding(10)
                                 .background(
                                     RoundedRectangle(cornerRadius: 10)
                                         .stroke(lineWidth: 0.5)
                                 )
                         }
                     }
                     .hAlign(.leading)
                     .multilineTextAlignment(.leading)
                 }
                 .padding()
                 
                 VStack {
                     Text("About \(audioQuiz.acronym)")
                         .fontWeight(.bold)
                         .foregroundStyle(.primary)
                         .hAlign(.leading)
                     Divider()
                     
                     Text(audioQuiz.about)
                         .font(.subheadline)
                         .fontWeight(.light)
                         .hAlign(.leading)
                 }
                 .padding()
                 .padding(.bottom)
                 
                 Rectangle()
                     .fill(.black)
                     .frame(height: 100)
             }
         }
     }
     .onChange(of: interactionState, { _, newState in
         updateState(newState)
     })
     .toolbar {
         ToolbarItem(placement: .navigationBarLeading) {
             Button(action: {dismiss()}, label: {
                 Image(systemName: "chevron.left.circle")
                     .foregroundStyle(.white)
             })
         }
     }
     .toolbar {
         ToolbarItem(placement: .navigationBarTrailing) {
             NavigationLink(destination: Text("Customize Page"), label: {
                 HStack(spacing: 4) {
                     Text("Customize")
                     Image(systemName: "slider.horizontal.3")
                 }
             })
             .foregroundStyle(.white)
         }
     }
 }
 .onAppear {
     updateViewColors()
     checkSampleAvailability()
     checkVersionAvailability()
 }
 .alert(item: $errorManager.currentError) { error in
     if hasDownloadedSample {
         return Alert(
             title: Text(error.alertTitle),
             message: Text(error.localizedDescription),
             dismissButton: .default(Text("Go to QuizPlayer")) {
                 user.downloadedQuiz = self.selectedAudioQuiz
                 errorManager.clearError()
                 selectedTab = 1 // Assuming 1 is the tab index for QuizPlayer
                 dismiss()
             }
         )
     } else {
         return Alert(
             title: Text(error.alertTitle),
             message: Text(error.localizedDescription),
             dismissButton: .default(Text("OK")) {
                 handleAlertAction(for: error)
             }
         )
     }
 }
//        .alert(item: $errorManager.currentError) { error in
//            Alert(
//                title: Text(error.alertTitle),
//                message: Text(error.localizedDescription),
//                dismissButton: .default(Text("OK")) {
//                    handleAlertAction(for: error)
//                }
//            )
//        }
 .preferredColorScheme(.dark)
}

private func handleAlertAction(for error: AppError) {
 switch error {
 case .downloadError:
     // Handle retry logic
     print("Retrying...")
 
 default:
     break
 }
 errorManager.clearError()
}

func sampleButtonInteraction() -> InteractionState {
 var state: InteractionState = .idle
 if isDownloadingSample {
     state = .isDownloading
     return state
 }
 return state
}
}
 
 
 */






