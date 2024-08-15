//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        BaseView {
          HomePage()
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
