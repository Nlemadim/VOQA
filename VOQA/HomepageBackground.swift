//
//  HomepageBackground.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct HomePageBackground: View {
    var body: some View {
        Image("VoqaIcon")
            .resizable()
            .frame(width: 700, height: 800)
            .overlay {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.6))
            }
    }
}


struct ChannelsBackgroundView: View {
    @State private var backgroundImage: String = "VoqaIcon"
    var body: some View {
        VStack {
            Image(backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 30)
                .blur(radius: 70)
                .offset(y: -160)
            
            Spacer().frame(height: 100)
        }
    }
}
