//
//  QuizActivityView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import Foundation
import SwiftUI

struct QuizActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage: String = "Activity"
    @Namespace private var animation

    var voqa: Voqa
    var onNavigateToQuizInfo: (Voqa) -> Void  // Callback to handle navigation

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView(voqa: voqa)
                
                PinnedHeaderView()
                
                VStack {
                    if currentPage == "Summary" {
                        Text("Summary Records Section")
                    } else if currentPage == "Core Topics" {
                        Text("Core Topics List Section")
                    } else if currentPage == "Q&A" {
                        Text("Q&A List Section")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .coordinateSpace(name: "SCROLL")
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func NarratorTabView() -> some View {
        let userAddonItems: [AddOnItem] = [gusVoiceItem, casandraVoiceItem, iniVoiceItem, dogonYaroVoiceItem]
        
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
    
    @ViewBuilder
    func HeaderView(voqa: Voqa) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            CachedImageView(imageUrl: voqa.imageUrl)
                .frame(width: size.width, height: height, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        // Dimming out text Content
                        LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.5),
                            .black.opacity(0.9)
                        ], startPoint: .top, endPoint: .bottom)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.white)
                                    .activeGlow(.white, radius: 1)
                                    .padding(.vertical)
                                    .allowsHitTesting(true)
                                    .onTapGesture {
                                        dismiss()
                                    }
                                
                                Spacer()
                                
                                Text(voqa.acronym)
                                    .font(.title.bold())
                                    .primaryTextStyleForeground()
                                
                                Label {
                                    Text("My Activities")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.7))
                                } icon: {}
                                .font(.caption)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CircularPlayButton2(
                                color: Color.fromHex(voqa.colors.main),
                                label: "Start",
                                progressMode: .quickLoad,
                                action: {
                                    onNavigateToQuizInfo(voqa)
                                }
                            )
                            .hAlign(.trailing)
                            .padding(.horizontal)
                            .padding(5)
                            .offset(y: -minY)
                        }
                    }
                }
                .cornerRadius(15)
                .offset(y: -minY)
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let pages: [String] = ["Latest Score", "Performance", "Q&A History", "Test Topics", "Contribute a Question", "Rate and Review"]
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
                                    .fill(.white)
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
            .padding(.top, 20)
            //.padding(.bottom, 25)
        }
    }
}

//#Preview {
//    return QuizActivityView(starttPressed: .constant(false), voqa: mockVoqa)
//        .preferredColorScheme(.dark)
//}

