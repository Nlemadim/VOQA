//
//  PackageEdition.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation


enum PackageEdition: Int, Codable, Identifiable, CaseIterable {
    case basic, curated, custom
    
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .basic:
            return "Basic Edition"
        case .curated:
            return "Curated Edition"
        case .custom:
            return "Customized Edition"
        }
    }
}
