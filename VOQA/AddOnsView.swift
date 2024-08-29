//
//  AddOnsView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import SwiftUI

struct AddOnsView: View {
    @State private var currentPage: String = "Narrators"
    @Namespace private var animation
    @StateObject private var viewModel: AddOnViewModel
    
    init(user: User, databaseManager: DatabaseManager) {
        _viewModel = StateObject(wrappedValue: AddOnViewModel(user: user, databaseManager: databaseManager))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                PinnedHeaderView()
                    .padding([ .top])
                Text("Customize your immersive learning experience")
                    .font(.footnote)
                    .foregroundStyle(.teal)
                    .fontWeight(.semibold)
                    .kerning(-0.5)
                    .hAlign(.leading)
                    .padding(.horizontal)
                
                switch currentPage {
                case "Narrators":
                    NarratorScrollView()
                case "Background Music":
                    MusicScrollView()
                case "Background Effects":
                    SoundEffectsScrollView()
                default:
                    NarratorScrollView() // Default to NarratorScrollView if no match
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Add Ons")
                                .font(.title)
                                .fontWeight(.black)
                                .kerning(-0.5)
                            Image(systemName: "cart.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
            .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func NarratorScrollView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach($viewModel.availableVoiceNarrators) { $item in
                    AddOnItemView(item: $item, download: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, sample: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, select: {
                        viewModel.selectVoiceNarrator(item)
                    })
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .background(Color.black)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func MusicScrollView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach($viewModel.availableMusicTracks) { $item in
                    AddOnItemView(item: $item, download: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, sample: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, select: {
                        viewModel.selectBackgroundMusic(item)
                    })
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .background(Color.black)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func SoundEffectsScrollView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach($viewModel.availableSoundEffects) { $item in
                    AddOnItemView(item: $item, download: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, sample: {
                        viewModel.downloadAndPlaySample(for: item)
                    }, select: {
                        viewModel.selectSoundEffect(item)
                    })
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .background(Color.black)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let pages = ["Narrators", "Background Music", "Background Effects"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(pages, id: \.self) { page in
                    VStack(spacing: 12) {
                        Text(page)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(currentPage == page ? .white : .gray)
                        
                        ZStack {
                            if currentPage == page {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.teal)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentPage = page
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 25)
        }
    }
}


#Preview {
    let user = User()
    let dbMgr = DatabaseManager.shared
    return AddOnsView(user: user, databaseManager: dbMgr)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        .environmentObject(user)
        .environmentObject(dbMgr)
}
