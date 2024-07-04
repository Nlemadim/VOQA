//
//  MiniPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import SwiftUI

struct MiniPlayer: View {
   
    @Binding var refreshQuiz: Bool
    @State var selectedOptionButton: String? = nil
   
    @Binding var expandSheet: Bool
    @State var presentMiniModal: Bool = false
   
    
    init(refreshQuiz: Binding<Bool>, expandSheet: Binding<Bool>) {
        _refreshQuiz = refreshQuiz
        _expandSheet = expandSheet
    }
        
    var body: some View {
        HStack(spacing: 10) {
            playerThumbnail
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    playerDetails
                    //currentQuizStatus
                    currentQuestionNumber
                }
            }
            .padding(.top, 10)
            
            MiniPlayerControls(
                recordAction: {},
                playPauseAction: {},
                nextAction: {},
                repeatAction: {})
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                expandSheet.toggle()
                presentMiniModal = false
            }
        }
    }
    
    private var playerThumbnail: some View {
        GeometryReader { geometry in
            Image("IconImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
        }
        .frame(width: 45, height: 45)
    }
    
    private var playerDetails: some View {
        Text("Not Playing")
            .font(.footnote)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4.0)
    }
    
    private var currentQuizStatus: some View {
        Text("Idle")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var currentQuestionNumber: some View {
        Text("VOQA")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MiniPlayer(refreshQuiz: .constant(false), expandSheet: .constant(false))
}
