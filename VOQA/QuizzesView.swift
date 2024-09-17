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
    
    var quizTopics: [String] // Array of quiz topics
    
    enum QuizTab: Int {
        case categories = 0
        case modifiers = 1
        case loading = 2
    }
    
    // Computed property to generate and sort categories from quizTopics
    var categories: [Category] {
        quizTopics.map { topicName in
            let isLocked = ["All Categories", "Learning Path", "Community Questions"].contains(topicName)
            let subtitle = isLocked ? "Subscribe to Unlock" : nil
            let icon = iconImage(topicName)
            return Category(name: topicName, subtitle: subtitle, isLocked: isLocked, iconName: icon)
        }
        .sorted { !$0.isLocked && $1.isLocked } // Sorts unlocked (false) before locked (true)
    }

    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Slide 1: Category Selection
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(categories) { category in
                            CategoryRow(category: category) {
                                if category.isLocked {
                                    showLockedAlert = true
                                } else {
                                    selectedCategory = category
                                    selectedTab = .modifiers
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
                Alert(title: Text("Locked"),
                      message: Text("Please subscribe to unlock this feature."),
                      dismissButton: .default(Text("OK")))
            }
            
            // Slide 2: Modifier Selection
            if let selectedCategory = selectedCategory {
                SelectModifiersView(selectedCategory: selectedCategory) {
                    selectedTab = .loading
                }
                .tag(QuizTab.modifiers)
            } else {
                // Placeholder if no category is selected
                VStack {
                    Text("No Category Selected")
                    Spacer()
                }
                .tag(QuizTab.modifiers)
            }
            
            // Slide 3: Loading Quiz
            LoadingQuizView {
                selectedTab = .categories
            }
            .tag(QuizTab.loading)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: selectedTab) // Smooth transition animation
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
    QuizzesView(quizTopics: ["Maths", "Physics", "Chemistry"])
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}


struct Category: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String?
    let isLocked: Bool
    let iconName: String // New property for the icon
}


// MARK: - CategoryRow View
struct CategoryRow: View {
    let category: Category
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Category Icon
            Image(systemName: category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(category.isLocked ? .gray : (category.iconName == "dot.scope" ? .orange : .teal))
                .accessibilityLabel(Text("Target Topic: \(category.name) Icon"))
            
            // Category Text
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.subheadline)
                   // .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: false)
                    .fixedSize(horizontal: false, vertical: true)
                
                if category.isLocked {
                    Text(category.subtitle ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
            
            // Lock or Play Button
            Button(action: {
                action()
            }) {
                if category.isLocked {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(category.isLocked ? Color.gray.opacity(0.1) : Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - ToggleSettingButton View
struct ToggleSettingButton: View {
    let imageName: String
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 60, height: 60)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .onTapGesture {
                isOn.toggle()
            }
            
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(width: 60)
        }
    }
}

// MARK: - SelectModifiersView
struct SelectModifiersView: View {
    let selectedCategory: Category
    let onStart: () -> Void
    
    // Using @AppStorage for UserDefaults synchronization
    @AppStorage("timerEnabled") private var timerEnabled: Bool = false
    @AppStorage("qaEnabled") private var qaEnabled: Bool = false
    @AppStorage("muteSpeaker") private var muteSpeaker: Bool = false
    @AppStorage("bgmEnabled") private var bgmEnabled: Bool = false
    @AppStorage("sfxEnabled") private var sfxEnabled: Bool = false
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select your Quiz Modifiers")
                .font(.headline)
                .padding(.bottom, 8)
            
            Text(selectedCategory.name)
                .font(.title2)
                .padding(.bottom, 16)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ToggleSettingButton(imageName: "timer", label: "Timer", isOn: $timerEnabled)
                ToggleSettingButton(imageName: "questionmark", label: "Q&A", isOn: $qaEnabled)
                ToggleSettingButton(imageName: "speaker.slash", label: "Mute Speaker", isOn: $muteSpeaker)
                ToggleSettingButton(imageName: "music.note", label: "BGM", isOn: $bgmEnabled)
                ToggleSettingButton(imageName: "waveform", label: "SFX", isOn: $sfxEnabled)
            }
            
            Spacer()
            
            Button(action: {
                onStart()
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

// MARK: - LoadingQuizView
struct LoadingQuizView: View {
    @State private var progress: Double = 0.0
    @State private var isCancelled: Bool = false
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Loading Quiz")
                .font(.headline)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
            
            Button(action: {
                isCancelled = true
                onCancel()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            startLoading()
        }
        .alert(isPresented: $isCancelled) {
            Alert(title: Text("Cancelled"), message: Text("Quiz loading has been cancelled."), dismissButton: .default(Text("OK")))
        }
    }
    
    func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.02
            if progress >= 1.0 {
                timer.invalidate()
                // Here you can handle the transition to the actual quiz view
            }
        }
    }
}
