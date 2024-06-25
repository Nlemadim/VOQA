//
//  QuizDetailPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/2/24.
//

import SwiftUI
import SwiftData

struct QuizDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject internal var generator = ColorGenerator()
    @Binding var selectedTab: Int
    
    var package: any QuizPackageProtocol
    
    init(package: any QuizPackageProtocol, selectedTab: Binding<Int>) {
        self.package = package
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image(package.titleImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    content
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "chevron.left.circle")
                            .foregroundStyle(.white)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Customize Page"), label: {
                        HStack(spacing: 4) {
                            Text("Customize")
                            Image(systemName: "slider.horizontal.3")
                        }
                    })
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: package.titleImage.isEmptyOrWhiteSpace ?  "VoqaIcon" : package.titleImage)
        }
        .preferredColorScheme(.dark)
    }
}


struct PlaySampleButton: View {
   
    var playAction: () -> Void
    
    var body: some View {
        Button(action: {
            
            playAction()
            
        }) {
            HStack(spacing: 4) {
                Text("Sample Question")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                // Conditionally display icon based on buttonState
//                if context == .isDownloading {
//                    SpinnerView() // Your custom spinner view
//                        .frame(width: 20, height: 20)
//                    
//                } else if interactionState == .isNowPlaying {
//                    Image(systemName: "pause.circle.fill")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                } else {
//                    Image(systemName: "play.circle.fill")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
                //Spacer()
            }
            .foregroundStyle(.white)
        }
    }
}

struct SpinnerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(lineWidth: 2)
            .foregroundStyle(.teal)
            .frame(width: 20, height: 20)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear() {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.isAnimating = true
                }
            }
    }
}

struct PlainClearButton: View {
    var color: Color
    var label: String
    var image: String?
    @State var isDisabled: Bool?
    var playAction: () -> Void

    var body: some View {
        Button(action: {
            self.isDisabled?.toggle()
            playAction()
        }) {
            
            if let image {
                HStack {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    
                    Text(label)
                        .font(.subheadline)
                }
            } else {
                Text(label)
                    .font(.subheadline)
            }
            
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(color)
        .foregroundColor(.white)
        .activeGlow(.white, radius: 1)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
        .disabled(isDisabled ?? false)
    }
}
