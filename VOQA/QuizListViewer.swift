//
//  QuizListViewer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation
import SwiftUI

struct VoqaTestView: View {
    var body: some View {
        Text("")
    }
    
}



#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return VoqaTestView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
}




