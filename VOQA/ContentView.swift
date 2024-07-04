//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
       Text("Hello VOQA")
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
