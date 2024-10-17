//
//  ChannelPlaylistCarouselView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/16/24.
//

import Foundation
import SwiftUI

struct ChannelPlaylistCarouselView2: View {
    let voqa: Voqa
    @ObservedObject var playlistManager: PlaylistManager
    @State private var currentItem: Int = 0
    let tapAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Quiz Playlist")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)  // Align leading

            if let playlists = playlistManager.playlists[voqa.id], !playlists.isEmpty {
                TabView(selection: $currentItem) {
                    ForEach(playlists) { playlist in
                        PlaylistRowView(playlist: playlist, isLoadingQuiz: false) {
                            tapAction()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 300)
            } else {
                // Show a placeholder or empty state if no playlists are available
                Text("No playlists available for this Voqa.")
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .frame(height: 300)
            }
        }
    }
}


