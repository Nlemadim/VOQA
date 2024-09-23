//
//  BgmSfx.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct BgmSfx: Codable, Hashable, Equatable {
    var title: String
    var audioUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case audioUrl
    }

    init(title: String, audioUrl: String) {
        self.title = title
        self.audioUrl = audioUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        audioUrl = try container.decode(String.self, forKey: .audioUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(audioUrl, forKey: .audioUrl)
    }

    // MARK: - Equatable Conformance

    static func == (lhs: BgmSfx, rhs: BgmSfx) -> Bool {
        return lhs.title == rhs.title &&
               lhs.audioUrl == rhs.audioUrl
    }

    // MARK: - Hashable Conformance

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(audioUrl)
    }
}
