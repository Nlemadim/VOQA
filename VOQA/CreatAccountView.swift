//
//  CreatAccountView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @AppStorage("log_Status") private var logStatus: Bool = false
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email
        case password
        case confirmPassword
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create an account")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 40)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Email", text: $user.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                
                SecureField("Password", text: $user.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .confirmPassword
                    }
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.done)
                    .onSubmit {
                        createAccount()
                    }
                
                Button(action: createAccount) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid())
                .opacity(isFormValid() ? 1 : 0.5)
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Automatically focus the email field when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .email
            }
        }
    }
    
    private func isFormValid() -> Bool {
        return !user.email.isEmpty && !user.password.isEmpty && !confirmPassword.isEmpty
    }
    
    private func createAccount() {
        guard !user.email.isEmpty, !user.password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        guard user.password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        logStatus = true
        // Save user credentials securely
        user.saveCredentials()
        
        // Notify parent view of successful account creation
        navigationRouter.goBack()
        // Optionally, navigate to another view if needed
        // navigationRouter.navigate(to: .nextView)
    }
}



#Preview {
    let user = User()
    let navMgr = NavigationRouter()
    return CreateAccountView()
        .environmentObject(user)
        .environmentObject(navMgr)
        .preferredColorScheme(.dark)
}
