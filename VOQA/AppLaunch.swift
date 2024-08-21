
//
//  AppLaunch.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/14/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct AppLaunch: View {
    @State private var startLoading: Bool = false
    @State private var transitionToSignIn: Bool = false
    @State private var zoomInProgress: Bool = false
    @State private var showSignInButton: Bool = false
    @State private var fadeToBlack: Bool = false
    @State private var showModal: Bool = false
    @State private var showName: Bool = false
    @State private var showDescriptionText: Bool = false
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    @Environment(\.colorScheme) private var scheme
    //User Log Status
    @AppStorage("log_Status") private var logStatus: Bool = false
    
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
                
                Text("Voiced Over Questions and Answers")
                    .font(.headline)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .opacity(transitionToSignIn || zoomInProgress  ? 0 : showName ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: transitionToSignIn)
            }
            .scaleEffect(zoomInProgress ? 2.5 : 1)
            .animation(.easeInOut(duration: 3), value: zoomInProgress)
            
            if fadeToBlack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 3), value: fadeToBlack)
            }
        }
        
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 120)
            
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 80, height: 80)
                
                CustomSpinnerView()
                    .frame(width: 45, height: 45)
                    .padding()
                    .padding(.top, 20)
                    .opacity(startLoading ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: startLoading)
            }
            
            if showSignInButton {
                VStack {
                    VStack {
                        withAnimation {
                            Text("Sign in to get started")
                                .font(.title)
                                .fontWeight(.ultraLight)
                                .hAlign(.center)
                                .padding(.bottom)
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        
                        SignInWithAppleButton { request in
                            let nonce = randomNonceString()
                            self.nonce = nonce
                            request.requestedScopes = [.email, .fullName]
                            request.nonce = sha256(nonce)
                        } onCompletion: { result in
                            switch result {
                                
                            case .success(let authorization):
                                loginWithFirebase(authorization)
                                
                            case .failure(let error):
                                let nsError = error as NSError
                                if nsError.code == ASAuthorizationError.canceled.rawValue {
                                    showError("Canceled sign-in process")
                                    
                                    
                                } else {
                                    showError(error.localizedDescription)
                                }
                            }
                        }
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .clipShape(.capsule)
                        .frame(height: 55)
                        
                        Button(action: {
                            
                        }) {
                            Text("Sign in as Guest")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                    }
                    .frame(height: 45)
                    .padding(20)
                    .padding(.bottom, 10)
                    
                }
                .offset(y: -20)
                .transition(.move(edge: isLoading ? .leading : .trailing))
            }
            
            if isLoading {
                VStack {
                    Text("Signing in")
                        .font(.title)
                        .fontWeight(.ultraLight)
                        .hAlign(.center)
                        .padding(.bottom)
                    
                    CustomSpinnerView()
                        .frame(width: 45, height: 45)
                        .padding()
                        .padding(.top, 20)
                        .opacity(isLoading ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: isLoading)
                }
            }
        }
        .alert(errorMessage, isPresented: $showAlert, actions: {
            
        })
        .onAppear {
            startLoading = true
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 35) { // Hide description text
                withAnimation {
                    startLoading = true
                    showDescriptionText = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 40) {
                withAnimation {
                    showName = false
                    showDescriptionText = false
                    startLoading = false
                    transitionToSignIn = true
                    zoomInProgress = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    withAnimation(.easeInOut) {
                        showSignInButton = true
                    }
                }
            }
        }
    }
    
    
    func loginWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Showing Loading screen until Auth process completion
            showSignInButton = false
            isLoading = true
            
            guard let nonce else {
                //fatalError("Invalid state: A login callback was received, but no login request was sent.")
                showError("Unable to process your request")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                //print("Unable to fetch identity token")
                showError("Unable to process your request")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                //print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                showError("Unable to process your request")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            //MARK: TODO - Expose createLibrary api from buildship
            // request body {userID: String, username: String, email: String}
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    showError(error.localizedDescription)
                    
                }
                
                // User signed in to Firebase with Apple
                //Push user to home View:
                
                isLoading = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 2)) {
                        zoomInProgress = false // Zoom back out
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            fadeToBlack = true
                        }
                        
                        logStatus = true
                    }
                }
            }
        }
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
}


#Preview {
    AppLaunch()
        .preferredColorScheme(.dark)
}


