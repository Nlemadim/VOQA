//
//  AppLaunch.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/14/24.
//

import SwiftUI

struct AppLaunch: View {
    @Binding var isUserSignedIn: Bool
    @State private var startLoading: Bool = false
    @State private var transitionToSignIn: Bool = false
    @State private var zoomInProgress: Bool = false
    @State private var showSignInButton: Bool = false
    @State private var fadeToBlack: Bool = false
    @State private var showModal: Bool = false
    @State private var showName: Bool = false
    @State private var showDescriptionText: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Image("VoqaIcon")
                    .resizable()
                    .frame(width: 220, height: 250)
                
                Text("VOQA")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .opacity(transitionToSignIn || zoomInProgress  ? 0 : showName ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: transitionToSignIn)
                
                // Special text between lines
                if showDescriptionText {
                    VStack {
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Text("Voiced Over Questions and Answers")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                    }
                    .opacity(showDescriptionText ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showDescriptionText)
                }
            }
            .scaleEffect(zoomInProgress ? 3 : 1)
            .animation(.easeInOut(duration: 3), value: zoomInProgress)
            
            if fadeToBlack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 3), value: fadeToBlack)
            }
        }
        
        VStack {
            Spacer()
                .frame(height: 120)
            
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 80, height: 80)
                
                CustomSpinnerView()
                    .frame(width: 50, height: 50)
                    .padding()
                    .padding(.top, 20)
                    .opacity(startLoading ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: startLoading)
            }
            
            if showSignInButton {
                Button(action: {
                    // Show the modal
                    showModal = true
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Sign in with Apple")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .padding()
                .transition(.move(edge: isUserSignedIn ? .leading : .trailing))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                withAnimation {
                    showName = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 14) { // Show description text
                withAnimation {
                    //showDescriptionText = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 19) { // Hide description text
                withAnimation {
                    startLoading = true
                    showDescriptionText = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 24) {
                withAnimation {
                    showName = false
                    showDescriptionText = false
                    startLoading = false
                    transitionToSignIn = true
                    zoomInProgress = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut) {
                        showSignInButton = true
                    }
                }
            }
        }
        .sheet(isPresented: $showModal) {
            // Modal content
            VStack {
                Button("Continue") {
                    showModal = false // Dismiss the modal
                    withAnimation(.easeInOut(duration: 1)) {
                        showSignInButton = false // Move the button back down
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 2)) {
                            zoomInProgress = false // Zoom back out
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation(.easeInOut(duration: 1)) {
                                fadeToBlack = true // Fade to black
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                                UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                                isUserSignedIn = true // Transition to BaseView
                            }
                        }
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.4)])
        }
    }
}


#Preview {
    AppLaunch(isUserSignedIn: .constant(false))
        .preferredColorScheme(.dark)
}

