//
//  ImageAndTitleView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (PacketCover) -> Void
    var packetCover: PacketCover

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(titleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .cornerRadius(10.0)
                .clipped()
                .accessibilityLabel(Text("Quiz image"))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(title))
                
                Text(packetCover.edition)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .accessibilityLabel(Text(packetCover.edition))
                
                if !packetCover.curator.isEmptyOrWhiteSpace {
                    Text("Curated by: " + packetCover.curator)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text("Curated by: \(packetCover.curator)"))
                }
                
                if packetCover.users > 0 {
                    Text("\(packetCover.users) users")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text("\(packetCover.users) users"))
                }
                
                if packetCover.rating > 0 {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            if index <= packetCover.rating {
                                Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.yellow)
                                    .accessibilityLabel(Text("Star filled"))
                            } else {
                                Image(systemName: "star")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                    .accessibilityLabel(Text("Star"))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .padding(.bottom, 20)
        .onTapGesture {
            tapAction(packetCover)
        }
        .accessibilityElement(children: .combine) // Combine all elements into a single accessibility element
        .accessibilityLabel(Text("Quiz: \(title)"))
    }
}
