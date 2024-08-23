//
//  CreatAccountView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import SwiftUI

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var user: User
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create an Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            TextField("Email", text: $user.email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            SecureField("Password", text: $user.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: createAccount) {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
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
        
        // Save user credentials securely
        user.saveCredentials()
        
        // Navigate back or show success message
        // For simplicity, assuming success
    }
}

