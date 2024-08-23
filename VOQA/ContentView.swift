//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = true
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        VoqaListView()
            .preferredColorScheme(.dark)
        //BaseView(logStatus: logStatus)
    }
}

#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
}

/**
 
 if logStatus {
     BaseView {
         HomePage()
     }
 } else {
     AppLaunch()
 }
 */

struct VoqaListView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var voqas: [Voqa] = []
    
    var body: some View {
        NavigationView {
            List(voqas, id: \.id) { voqa in
                HStack(spacing: 16) {
                    // AsyncImage to load the image from the imageUrl
                    if let url = URL(string: voqa.imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            case .failure:
                                Image("IconImage") // Use your placeholder image here
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(voqa.acronym)
                            .font(.headline)
                        
                        Text(voqa.quizTitle)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Quizzes")
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        Task {
            await databaseManager.fetchQuizCollection()
            let quizCollection = databaseManager.quizCollection
            voqas = quizCollection.map { Voqa(from: $0) }
        }
    }
}

