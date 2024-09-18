
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
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var startLoading: Bool = false
    @State private var transitionToSignIn: Bool = false
    @State private var zoomInProgress: Bool = false
    @State private var showSignInButton: Bool = false
    @State private var fadeToBlack: Bool = false
    @State private var showName: Bool = false
    @State private var showDescriptionText: Bool = false
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    @AppStorage("log_Status") private var logStatus: Bool = false
    @State var loadCatalogue: Bool = false // Initialized to a default value

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Image("VoqaIcon")
                    .resizable()
                    .frame(width: 220, height: 250)
                
                Text("VOQA")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .opacity(transitionToSignIn || zoomInProgress ? 0 : showName ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: transitionToSignIn)
                
                Text("Voiced Over Questions and Answers")
                    .font(.headline)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .opacity(transitionToSignIn || zoomInProgress ? 0 : showName ? 1 : 0)
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
                    .opacity(loadCatalogue ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: loadCatalogue)
            }
            
            if showSignInButton {
                VStack {
                    Text(isLoading ? "Signing in" : "Sign in to get started")
                        .font(.title)
                        .fontWeight(.ultraLight)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom)
                    
                    SignInWithAppleButton { request in
                        let nonce = randomNonceString()
                        self.nonce = nonce
                        request.requestedScopes = [.email, .fullName]
                        request.nonce = sha256(nonce)
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            signInWithApple(authorization: authorization)
                        case .failure(let error):
                            handleSignInError(error)
                        }
                    }
                    .signInButtonStyle()
                    
                    Button(action: {
                        // Navigate to Create Account
                        navigationRouter.navigate(to: .createAccount)
                    }) {
                        Text("Create an Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.clear)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        user.continueAsGuest()
                        logStatus = true
                        navigationRouter.goBack()
                    }) {
                        Text("Continue as Guest")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.clear)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .offset(y: -20)
                .transition(.move(edge: isLoading ? .leading : .trailing))
            }
        }
        .alert(errorMessage, isPresented: $showAlert, actions: {})
        .onAppear {
            performInitialAnimations()
        }
        .onDisappear {
            if user.isLoggedIn {
                Task {
                    do {
                        try await createUser()
                    } catch {
                        print("Failed to create user profile: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // MARK: - Updated Sign In with Apple Method

    private func signInWithApple(authorization: ASAuthorization) {
        guard let nonce = nonce else {
            showError("Unable to process your request")
            return
        }
        
        FirebaseManager.shared.loginWithFirebase(authorization: authorization, nonce: nonce) { result in
            switch result {
            case .success:
                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    // Update UserConfig properties directly
                    DispatchQueue.main.async {
                        user.userConfig.email = appleIDCredential.email ?? ""
                        
                        let givenName = appleIDCredential.fullName?.givenName ?? ""
                        let familyName = appleIDCredential.fullName?.familyName ?? ""
                        user.userConfig.username = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                        
                        // Assign Beta subscription access
                        let betaAccess = AccountType.beta.packageAccess.map { $0.rawValue }
                        let badges = [Badges.betaAccessUser.rawValue]
                        
                        // Update UserConfig with Beta access, badges, and account type
                        user.userConfig.accountType = AccountType.beta.rawValue
                        user.userConfig.subscriptionPackages = betaAccess
                        user.userConfig.badges = badges
                        
                        // No need to set isLoggedIn manually; it's derived from accountType
                    }
                }
                handleSuccessfulSignIn()
            case .failure(let error):
                showError(error.localizedDescription)
            }
        }
    }

    // MARK: - Other Methods (Unchanged)

    private func handleSignInError(_ error: Error) {
        let nsError = error as NSError
        if nsError.code == ASAuthorizationError.canceled.rawValue {
            showError("Canceled sign-in process")
        } else {
            showError(error.localizedDescription)
        }
    }
    
    private func handleSuccessfulSignIn() {
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
    
    private func performInitialAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showName = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                startLoading = true
                showDescriptionText = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
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
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in charset[Int(byte) % charset.count] }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    
    private func createUser() async throws {
        try await databaseManager.createUserProfile(for: user)
    }
}


#Preview {
    let user = User()
    let dbMgr = DatabaseManager.shared
    return AppLaunch(loadCatalogue: true)
        .environmentObject(user)
        .environmentObject(dbMgr)
        .preferredColorScheme(.dark)
}


