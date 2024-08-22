//
//  VoqaCollection.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import SwiftUI

struct VoqaCollection: VoqaConfiguration, Identifiable, Decodable {
    var id: UUID = UUID()
    var category: String
    var subtitle: String
    var quizzes: [Voqa]
    
    private enum CodingKeys: String, CodingKey {
        case category, subtitle, quizzes
    }
}

struct VoqaConfig: Decodable {
    var voqaCollection: [VoqaCollection]
}
