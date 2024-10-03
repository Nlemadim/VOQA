//
//  BgmSfx.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct BgmSfx: Codable, Hashable, Equatable {
    var title: String
    var urlScript: String
    var audioUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case urlScript
        case audioUrl
    }

    // Complete Initializer with all properties
    init(title: String, urlScript: String, audioUrl: String) {
        self.title = title
        self.urlScript = urlScript
        self.audioUrl = audioUrl
    }

    // Codable Conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        urlScript = try container.decode(String.self, forKey: .urlScript)
        audioUrl = try container.decode(String.self, forKey: .audioUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(urlScript, forKey: .urlScript)
        try container.encode(audioUrl, forKey: .audioUrl)
    }

    // MARK: - Equatable Conformance

    static func == (lhs: BgmSfx, rhs: BgmSfx) -> Bool {
        return lhs.title == rhs.title &&
               lhs.urlScript == rhs.urlScript &&
               lhs.audioUrl == rhs.audioUrl
    }

    // MARK: - Hashable Conformance

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(urlScript)
        hasher.combine(audioUrl)
    }
}



//struct BgmSfx: Codable, Hashable, Equatable {
//    var title: String
//    var urlScript: String
//    var audioUrl: String
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case urlScript
//        case audioUrl
//    }
//
//    init(title: String, audioUrl: String) {
//        self.title = title
//        self.audioUrl = audioUrl
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: .title)
//        audioUrl = try container.decode(String.self, forKey: .audioUrl)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(title, forKey: .title)
//        try container.encode(audioUrl, forKey: .audioUrl)
//    }
//
//    // MARK: - Equatable Conformance
//
//    static func == (lhs: BgmSfx, rhs: BgmSfx) -> Bool {
//        return lhs.title == rhs.title &&
//               lhs.audioUrl == rhs.audioUrl
//    }
//
//    // MARK: - Hashable Conformance
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(title)
//        hasher.combine(audioUrl)
//    }
//}
