//
//  MyChannelItemsView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//


import Foundation
import SwiftUI
import Shimmer

// ChannelListView: Displays a list of Voqa items

struct ChannelListView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    var voqaCollection: [Voqa]  // Use concrete type Voqa
    var onSelectVoqa: (Voqa) -> Void  // Change to use Voqa

    var body: some View {
        VStack {
            Text("Audio Quiz Channels")
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                .hAlign(.leading)
            // Show empty placeholder cells if the collection is empty
            ScrollView(showsIndicators: false) {
                if voqaCollection.isEmpty {
                    ForEach(0..<25, id: \.self) { _ in
                        Divider()
                            .padding(.horizontal)
                        MyChannelItemPlaceholderView()
                            .background(Color.black)
                        Divider()
                            .padding(.horizontal)
                    }
                } else {
                    // Display each Voqa item in the list
                    ForEach(voqaCollection, id: \.id) { voqa in
                        VStack {
                            Divider()
                                .padding(.horizontal)
                            
                            MyChannelItemView(audioQuiz: voqa) { selectedVoqa in
                                onSelectVoqa(selectedVoqa)
                            }
                            
                            Divider()
                                .padding(.horizontal)
                            
                            Spacer()
                                
                        }
                        .background(Color.black) // Set background color for each item view
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black) // Set the overall background color of the List
       /* .listStyle(PlainListStyle())*/ // Use plain list style for better control over appearance
        .frame(maxHeight: .infinity) // Allow the list to take up infinite height
    }
}


// MyChannelItemView: Displays an individual Voqa item
struct MyChannelItemView: View {
    @EnvironmentObject var user: User
    var audioQuiz: Voqa  // Change to use Voqa directly
    var onTap: (Voqa) -> Void  // Change type to Voqa

    var body: some View {
        Button(action: {
            onTap(audioQuiz)
        }, label: {
            HStack(spacing: 12) {
                Image(systemName: user.currentUserVoqa?.acronym == audioQuiz.acronym ? "square.fill" : "square")
                    .foregroundStyle(user.currentUserVoqa?.acronym == audioQuiz.acronym ? .teal : .gray)
                
                CachedImageView(imageUrl: audioQuiz.imageUrl)
                    .frame(width: 55, height: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(audioQuiz.acronym)
                        .fontWeight(.semibold)
                        .font(.caption)
                       
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        })
        .foregroundStyle(.primary)
    }
}


struct MyChannelItemPlaceholderView: View {
    var body: some View {
        HStack(spacing: 12) {
            // Placeholder for checkbox or icon
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 20, height: 20)
                .cornerRadius(3)
                .shimmering() // Add shimmering effect

            // Placeholder for image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shimmering() // Add shimmering effect

            VStack(alignment: .leading, spacing: 8) {
                // Placeholder for text
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 15)
                    .cornerRadius(5)
                    .shimmering() // Add shimmering effect
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}

