//
//  LogoFlashView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI

struct LogoFlashView: View {
    @Binding var selectedTab: Int
    @State private var isLoadingDefaults: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("VoqaIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, alignment: .center)
                    .padding(.bottom, 30)
                Text("voqa".uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .kerning(-0.5)

                ProgressView()
                    .foregroundStyle(.teal)
                    .scaleEffect(1)
                    .padding(25)
                    .opacity(isLoadingDefaults ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .onAppear {
                loadUserDefaults()
            }
            .preferredColorScheme(.dark)
        }
    }

    private func loadUserDefaults() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoadingDefaults.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                selectedTab = 1
            }
        }
    }
}

#Preview {
    LogoFlashView(selectedTab: .constant(0))
}
