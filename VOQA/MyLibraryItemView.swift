//
//  MyChannelItemView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

//import Foundation
//import SwiftUI
//import Shimmer
//
//struct ChannelListView: View {
//    var voqaCollection: [Voqa]
//    var onSelectVoqa: (Voqa) -> Void
//
//    var body: some View {
//        List {
//            if voqaCollection.isEmpty {
//                ForEach(0..<25, id: \.self) { _ in
//                    MyChannelItemPlaceholderView()
//                }
//            } else {
//                ForEach(voqaCollection, id: \.self) { voqa in
//                    MyChannelItemView(audioQuiz: voqa) { voqa in
//                        onSelectVoqa(voqa)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct MyChannelItemView: View {
//    @EnvironmentObject var user: User
//    var audioQuiz: Voqa
//    var onTap: (Voqa) -> Void
//
//    var body: some View {
//        Button(action: {
//            onTap(audioQuiz)
//        }, label: {
//            HStack(spacing: 12) {
//                Image(systemName: user.currentUserVoqa?.acronym == audioQuiz.acronym ? "square.fill" : "square")
//                    .foregroundStyle(user.currentUserVoqa?.acronym == audioQuiz.acronym ? .teal : .gray)
//                
//                CachedImageView(imageUrl: audioQuiz.imageUrl)
//                    .frame(width: 55, height: 55)
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(audioQuiz.acronym)
//                        .fontWeight(.semibold)
//                        .font(.caption)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        })
//    }
//}
//
//struct MyChannelItemPlaceholderView: View {
//    var body: some View {
//        HStack(spacing: 12) {
//            // Placeholder for checkbox or icon
//            Rectangle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(width: 20, height: 20)
//                .cornerRadius(3)
//                .shimmering() // Add shimmering effect
//
//            // Placeholder for image
//            Rectangle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(width: 55, height: 55)
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                .shimmering() // Add shimmering effect
//
//            VStack(alignment: .leading, spacing: 8) {
//                // Placeholder for text
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 100, height: 15)
//                    .cornerRadius(5)
//                    .shimmering() // Add shimmering effect
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding(.vertical, 8)
//    }
//}
