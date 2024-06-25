//
//  Tab.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case explore
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .profile: return "Profile"
        }
    }
    
    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .explore: return Image(systemName: "magnifyingglass")
        case .profile: return Image(systemName: "person.circle")
        }
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
