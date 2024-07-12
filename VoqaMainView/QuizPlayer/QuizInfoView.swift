//
//  QuizInfoView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import SwiftUI

struct QuizInfoView: View {
    let selectedVoqa: Voqa
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                if let url = URL(string: selectedVoqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            VStack(alignment: .center) {
                Text(selectedVoqa.name)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .center) {
                Text(selectedVoqa.about)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                // Action for starting the quiz
            }) {
                Text("Start Assessment Quiz")
                    .fontWeight(.black)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.bottom, 20)
        }
        .frame(maxHeight: .infinity)
        .background {
            if let url = URL(string: selectedVoqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 3.0)
                            .offset(x: -100)
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.red)
                            .blur(radius: 3.0)
                            .offset(x: -100)
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.red)
                    .blur(radius: 3.0)
                    .offset(x: -100, y: 60)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.6))
                    }
            }
        }
    }
}

#Preview {
    QuizInfoView(selectedVoqa: Voqa(id: UUID(), name: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "", rating: 3, curator: "John Doe", users: 1000))
        .preferredColorScheme(.dark)
}
