//
//  AudioPlyerTestViews.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import SwiftUI

struct BaseMainView: View {
    @State private var currentView: String = "Home"
    @State private var showProfile = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        Image("VoqaIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: getOffset().width, y: getOffset().height)
                            .animation(.easeInOut(duration: 2.0), value: currentView)
                            .offset(y: -60)
                    }
                }

                VStack {
                    switch currentView {
                    case "Home":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom))
                            .overlay {
                                VStack {
                                    Text("Home Screen")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    case "Profile":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .leading))
                            .overlay {
                                VStack {
                                    Text("Profile View Content")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    case "Settings":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .trailing))
                            .overlay {
                                VStack {
                                    Text("Settings View Content")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    default:
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 700)
                        //Text("Home View Content")
                    }
                }
                .font(.title)
                .padding()
                .animation(.easeInOut(duration: 2.0), value: currentView)
                
            }
            .navigationTitle(getTitle())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            currentView = "Profile"
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            currentView = "Settings"
                        }
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                switch currentView {
                case "Home":
                    withAnimation {
                        currentView = "Profile"
                    }
                case "Profile":
                    withAnimation {
                        currentView = "Settings"
                    }
                case "Settings":
                    withAnimation {
                        currentView = "Home"
                    }
                default:
                    withAnimation {
                        currentView = "Home"
                    }
                }
            }
        }
    }
    
    private func getTitle() -> String {
        switch currentView {
        case "Home":
            return "Home"
        case "Profile":
            return "Profile"
        case "Settings":
            return "Settings"
        default:
            return "Home"
        }
    }

    private func getOffset() -> CGSize {
        switch currentView {
        case "Home":
            return .zero
        case "Profile":
            return CGSize(width: 350, height: -250)
        case "Settings":
            return CGSize(width: -350, height: 250)
        default:
            return .zero
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseMainView()
//    }
//}





