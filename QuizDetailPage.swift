//
//  QuizDetailPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/2/24.
//

import SwiftUI

struct QuizDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    var audioQuiz: Voqa // Changed from Binding to a simple property

    @State private var hasDownloadedSample: Bool = false
    @State private var hasFullVersion: Bool = false
    @State private var isDownloading:  Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.fromHex(audioQuiz.colors.main), .black]), startPoint: .top, endPoint: .bottom)
                )
            
            VStack(alignment: .center) {
                
            }
            .frame(height: 280)
            .background(Color.fromHex(audioQuiz.colors.main).gradient)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(spacing: 5) {
                        AsyncImage(url: URL(string: audioQuiz.imageUrl)) { image in
                            image
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 250, height: 250)
                        }
                        
                        Text(audioQuiz.acronym)
                            .lineLimit(4, reservesSpace: false)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .hAlign(.center)
                        
                        if audioQuiz.acronym != audioQuiz.quizTitle {
                            Text(audioQuiz.quizTitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .hAlign(.center)
                        }
                        
                        if audioQuiz.curator.isEmptyOrWhiteSpace {
                            Text("Curated by: Gista Society")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .hAlign(.center)
                        }
                        
                        Text("Users: \(audioQuiz.users)")
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .hAlign(.center)
                             
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= audioQuiz.rating ? "star.fill" : "star")
                                    .imageScale(.small)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .frame(maxWidth:.infinity)
                    .padding()
                    .hAlign(.center)
                    
                    VStack(alignment: .leading) {
                        AddToLibraryButton(color: Color.fromHex(audioQuiz.colors.third), label: "Join Channel", playAction: {
                            
                        })
                        .foregroundStyle(Color.fromHex(audioQuiz.colors.third).dynamicTextColor())
                        .padding(.horizontal)
                        .padding()
                        .padding(.top)
                        .hAlign(.center)
                        
                    }
                    .disabled(isDownloading)
                    .padding(.horizontal)
                    .padding(5)
                    
                }
                .padding(.horizontal)
                //.offset(y: -40)
                
                VStack {
                    
                    Text("Category")
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)
                    
                    HStack(spacing: 16.0) {
                        
                        ForEach(audioQuiz.tags, id: \.self) { category in
                            Text(category)
                                .font(.system(size: 10))
                                .fontWeight(.light)
                                .lineLimit(1)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 0.5)
                                )
                        }
                    }
                    .hAlign(.leading)
                    .multilineTextAlignment(.leading)
                }
                .padding()
                
                VStack {
                    Text("About \(audioQuiz.acronym)")
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)
                    Divider()
                    
                    Text(audioQuiz.about)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .hAlign(.leading)
                }
                .padding()
                .padding(.bottom)
                
                Rectangle()
                    .fill(.black)
                    .frame(height: 100)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left.circle")
                        .foregroundStyle(.white)
                })
            }
        }
    }
}
