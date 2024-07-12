//
//  QuizPlayerBackground.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//


import Foundation
import SwiftUI

struct QuizPlayerBackground: View {
    var backgroundImageResource: String
    
    var body: some View {
        if let url = URL(string: backgroundImageResource.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.9))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 3.0)
                        .offset(x: -100)
                        .overlay {
                            Rectangle()
                                .foregroundStyle(.black.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure:
                    Color.black
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}



#Preview {
    QuizPlayerBackground(backgroundImageResource: "https://storage.googleapis.com/buildship-ljnsun-us-central1/Human Anatomy and Physiology.png")
        .preferredColorScheme(.dark)
}

