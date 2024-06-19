//
//  LaunchView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI
import WebKit
import AVFoundation

struct LaunchView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LogoFlashView(selectedTab: $selectedTab)
                .tag(0)
                .tabItem { EmptyView() }
            
            PrivacyPolicyView(selectedTab: $selectedTab)
                .tag(1)
                .tabItem { EmptyView() }

            TermsAndConditionsView(selectedTab: $selectedTab)
                .tag(2)
                .tabItem { EmptyView() }

            VoqaWebView()
                .tag(3)
                .tabItem { EmptyView() }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .toolbar(.hidden, for: .tabBar)
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    LaunchView()
}
