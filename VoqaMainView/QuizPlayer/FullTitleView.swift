//
//  FullTitleView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import Foundation
import SwiftUI

struct FullTitleView: View {
    var quiz: Voqa
    let tapAction: (Voqa) -> Void
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: quiz.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                       // .frame(width: 320, height: 360)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                case .failure:
                    VStack{
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .offset(y: 30)
                            .foregroundColor(.orange)
                    }
                    .frame(width: 320, height: 360)
                @unknown default:
                    EmptyView()
                }
            }
            
            NamePlateBaseView {
                NamePlateView(quiz: quiz)
            }
        }
        .cornerRadius(10.0)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        
    }
}

// NamePlateBaseView
struct NamePlateBaseView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(8)
            .frame(height: 200)
            .frame(maxWidth: .infinity)
    }
}

// NamePlateView
struct NamePlateView: View {
    var quiz: Voqa
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quiz.name.uppercased())
                .font(.system(size: 13))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fontWeight(.bold)
            
            if let users = quiz.users {
                Text("\(users) Ratings")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
            }
            
            Text(aboutText)
                .font(.system(size: 13))
                .multilineTextAlignment(.leading)
                //.fontWeight(.bold)
            
            if let rating = quiz.rating {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        if index <= rating {
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                                .imageScale(.small)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        
    }
}


let aboutText = "In this captivating audiobook, join Alex, a young programmer navigating the complex world of software development. As he embarks on his journey, he encounters seasoned mentors, cryptic bugs, and the elusive “Elegant Algorithm.” Through their guidance, Alex learns that software engineering is more than just writing code"
