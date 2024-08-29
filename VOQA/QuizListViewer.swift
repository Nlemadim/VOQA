//
//  QuizListViewer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation
import SwiftUI

struct VoqaTestView: View {
    @State private var userAddonItems: [AddOnItem] = [gusVoiceItem, casandraVoiceItem, iniVoiceItem, dogonYaroVoiceItem]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(userAddonItems, id: \.name) { item in
                    QuizAddOnItem(item: item)
                        .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 350)
            .onAppear {
                userAddonItems[0].isSelected = true
            }
        }
    }
}

struct AddonTestModel {
    let itemName: String
    let itemImage: String?
    let itemDescription: String
    let sampleAudioURL: String?
    let itemImageUrl: String?
}

let gusVoiceItem = AddOnItem(name: "Gus", imageName: "Gus", about: "Gus is a straight to the point narrator who will keep things moving without much delay")
let casandraVoiceItem = AddOnItem(name: "Erin", imageName: "Erin", about: "Erin is an ancient librarian. She is very thorough and values accuracy very highly")
let iniVoiceItem = AddOnItem(name: "Ini", imageName: "Ini", about: "Ini is a technology futurist. He deeply appreciates novelty and innovation.")
let dogonYaroVoiceItem = AddOnItem(name: "Dogon Yaro", imageName: "DogonYaro", about: "Dogon Yaro only speaks when there is much to say")



#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return VoqaTestView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
}

#Preview {
    NarratorView()
        .preferredColorScheme(.dark)
}


struct NarratorView: View {
    @State private var userAddonItems: [AddOnItem] = [gusVoiceItem, casandraVoiceItem, iniVoiceItem, dogonYaroVoiceItem]
    var body: some View {
        VStack {
            
            TabView {
                ForEach(userAddonItems, id: \.name) { item in
                    QuizAddOnItem(item: item)
                        .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct QuizAddOnItem: View {
    @State private var isSelected: Bool = false
    var item: AddOnItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            narratorImage
            
            VStack(alignment: .leading, spacing: 10) {
                narratorDetails
                
                Spacer() // Push buttons to the bottom
                
                sampleButtons
            }
            .frame(height: 200) // Match the image height to ensure the text doesn't exceed it
        }
        .padding(.horizontal)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(Material.ultraThin)
                .frame(height: 230)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 230)
        )
    }
    
    // ViewBuilder for the narrator image and select button
    private var narratorImage: some View {
        Image(item.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .cornerRadius(10)
            .overlay {
                ZStack {
                    VStack {
                        Spacer()
                        Button(action: {
                            isSelected.toggle()
                        }) {
                            Text(isSelected ? "Selected" : "Select")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                                .background(isSelected ? Color.green : Color.white.opacity(0.5))
                                .foregroundColor(isSelected ? .white : .black)
                                .cornerRadius(5)
                        }
                    }
                }
            }
    }
    
    // ViewBuilder for the narrator details
    private var narratorDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(item.about)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // ViewBuilder for the sample buttons
    private var sampleButtons: some View {
        VStack(spacing: 5) {
            SmallDownloadButton(label: "Download", color: Color.teal.opacity(0.5), iconImage: "arrow.down.circle", action: {
                
            })
            SmallDownloadButton(label: "Sample", color: Color.white.opacity(0.5), iconImage: "speaker.fill", action: {
                
            })
        }
    }
}

