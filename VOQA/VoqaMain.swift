//
//  VoqaMain.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/8/24.
//

import SwiftUI

struct VoqaMain: View {
    var body: some View {
        HomeView()
            .tint(.white).activeGlow(.white, radius: 2)
    }
}

struct HomeView: View {
    @State private var selectedTab = 0
    @State private var path = NavigationPath()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            CustomHorizontalScrollView(quizzes: voqas, title: "Top Rated", tapAction: {_ in })
                            
                            CustomHorizontalScrollView(quizzes: voqas, title: "Top Rated", tapAction: {_ in })
                            
                            CustomHorizontalScrollView(quizzes: voqas, title: "Top Rated", tapAction: {_ in })
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 100)
                        }
                    }
                    .background {
                        VoqaBackground()
                    }
                    .zIndex(1)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Text("VOQA")
                                .font(.title)
                                .fontWeight(.black)
                                .kerning(-0.5)
                                .primaryTextStyleForeground()
                        }
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
    }
}


struct PerformanceView: View {
    var body: some View {
        Text("Performance View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}


struct TabIcons: View {
    var title: String
    var icon: String
    
    var body: some View {
        // Tab Icons content here
        Label(title, systemImage: icon)
    }
}


#Preview {
    VoqaMain()
        .preferredColorScheme(.dark)
}

struct VoqaBackground: View {
    var body: some View {
        Image("Icon")
            .resizable()
            .frame(width: 700, height: 800)
            .offset(x: -180)
            .blur(radius: 3.0)
    }
}


//struct BackgroundView: View {
//    var backgroundImage: String
//    var color: Color
//    
//    var body: some View {
//        Rectangle()
//            .fill(.clear)
//            .frame(height: 300)
//            .background(
//                LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom)
//            )
//            .overlay {
//                Image(backgroundImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .clipped()
//            }
//            .frame(height: 300)
//            .blur(radius: 100)
//    }
//}


struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (Voqa) -> Void
    var quiz: Voqa

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(titleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 200)
                .cornerRadius(10.0)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.bold)
            
                
                if let users = quiz.users {
                    Text("\(users) users")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
                
                if let rating = quiz.rating {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            if index <= rating {
                                Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                    
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        
        .background(RoundedRectangle(cornerRadius: 15.0).fill(Material.ultraThin).tint(.white).activeGlow(.white, radius: 2))
        .padding(10)
        .padding(.bottom, 20)
        .onTapGesture {
            tapAction(quiz)
        }
    }
}


struct Voqa: Identifiable, Hashable {
    var id: UUID
    var name: String
    var acronym: String
    var about: String
    var imageUrl: String
    var rating: Int?
    var curator: String?
    var users: Int?
    
    // Conforming to Hashable protocol
    static func == (lhs: Voqa, rhs: Voqa) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

