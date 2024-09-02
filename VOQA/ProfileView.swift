//
//  ProfileView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    profileSection
                    subscriptionAccessSection
                    badgesSection
                    listSection
                    logoutButton
                }
                .padding()
            }
        }
    }
    
    // MARK: - Profile Information Section
    private var profileSection: some View {
        HStack(alignment: .top, spacing: 16) {
            profileImage
                .alignmentGuide(.top) { _ in 0 }

            VStack(alignment: .leading, spacing: 8) {
                Text(user.fullName.isEmpty ? "Hi Anonymous" : "Hello, \(user.fullName)!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .alignmentGuide(.top) { _ in 0 }
                   
                Text("\(user.userConfig.accountType) Subscriber")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top)
    }
    
    private var profileImage: some View {
        Group {
            if let profileImage = user.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.teal)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.teal, lineWidth: 2))
            }
        }
    }
    
    // MARK: - Subscription Access Section
    private var subscriptionAccessSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Subscription Access:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom)
            
            if !user.userConfig.subscriptionPackages.isEmpty {
                emptyAccessView
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 10), count: 2), spacing: 10) {
                    
                    ForEach(0..<4) { items in
                        accessItemView(item: "item")
                            
                    }
                    
                    ForEach(user.userConfig.subscriptionPackages, id: \.self) { item in
                        accessItemView(item: item)
                    }
                }
            }
        }
        .frame(height: 200, alignment: .top)
        .padding(.top)
    }
    
    private var emptyAccessView: some View {
        Text("Sign in to get access.")
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
    }
    
    private func accessItemView(item: String) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.teal.opacity(0.7))
                .frame(width: 100, height: 80)
                .cornerRadius(10)
                .overlay {
                    Text(item)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
               
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        VStack(alignment: .leading) {
            Text("Badges")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            if user.userConfig.badges.isEmpty {
                emptyBadgeView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(user.userConfig.badges, id: \.self) { badge in
                            badgeView(badge: badge)
                        }
                    }
                }
                .frame(height: 60)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var emptyBadgeView: some View {
        VStack {
            Image(systemName: "medal")
                .resizable()
                .frame(width: 30, height: 35)
                .foregroundColor(.gray)
            Text("You have no badges yet.")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func badgeView(badge: String) -> some View {
        VStack {
            Image(systemName: "medal.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.yellow)
            Text(badge)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
    
    private func badgesIcon(_ numberOfBadges: Int) -> some View {
        NavigationLink(destination: Text("Badges")) {
            VStack(spacing: 8) {
                Text("Badges")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Image(systemName: "medal.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(numberOfBadges > 0 ? .yellow : .secondary)
                Text("\(numberOfBadges)")
                    .font(.footnote)
                    .foregroundColor(numberOfBadges > 0 ? .yellow : .secondary)
            }
            .padding()
        }
    }
    
    // MARK: - List Section for Short Items
    private var listSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            NavigationLink(destination: Text("Terms and Conditions")) {
                PageLinkView(title: "Terms and Conditions")
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            }
            
            NavigationLink(destination: Text("Privacy")) {
                PageLinkView(title: "Privacy")
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            }
            
            NavigationLink(destination: Text("FAQs")) {
                PageLinkView(title: "FAQs")
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            }
            
            NavigationLink(destination: Text("Delete Account")) {
                PageLinkView(title: "Delete My Account")
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.top)
    }

    
    // MARK: - Delete Account Button
    private var deleteAccountButton: some View {
        Button(action: {
            user.clearCredentials()
        }) {
            Text("Delete My Account")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding(.top)
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            user.isLoggedIn = false
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 30, height: 30)
                    
                Text("Logout")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .padding()
            .foregroundColor(Color.orange)
           
        }
    }
}


#Preview {
    let user = User()
    return ProfileView()
        .environmentObject(user)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
