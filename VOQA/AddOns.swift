//
//  AddOns.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import SwiftUI

struct AddOns: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Avatar")) {
                    HGridContent(items: ["person.circle", "person.circle.fill", "person.crop.circle", "person.crop.circle.fill"])
                }

                Section(header: Text("Select Voice")) {
                    HGridContent(items: ["waveform.path.ecg", "waveform.path", "mic", "mic.fill"])
                }

                Section(header: Text("Select Answer Assistant")) {
                    HGridContent(items: ["questionmark.circle", "questionmark.circle.fill", "brain.head.profile", "brain"])
                }

                Section(header: Text("Select Sound Effect"), footer: Text("Play sounds like raindrops or waterfall in the background")) {
                    HGridContent(items: ["drop", "drop.fill", "cloud.rain", "cloud.heavyrain"])
                }

                Section(header: Text("Select Music"), footer: Text("Add podcast-style background music to your quiz")) {
                    HGridContent(items: ["music.note", "music.note.list", "headphones", "guitar"])
                }
            }
            .navigationTitle("Add Ons")
            .foregroundColor(.white)
        }
    }
}

struct HGridContent: View {
    let items: [String]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 4) // Create a grid with 4 items per row
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items, id: \.self) { item in
                VStack {
                    Image(systemName: item)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                    Text(item)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
    }
}


#Preview {
    AddOns()
}
