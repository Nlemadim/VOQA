//
//  VoicedFeedback.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct VoicedFeedback: Codable, Hashable, Equatable {
    var title: String
    var audioUrls: [FeedbackSfx]

    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }

    init(title: String, audioUrls: [FeedbackSfx]) {
        self.title = title
        self.audioUrls = audioUrls
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        audioUrls = try container.decode([FeedbackSfx].self, forKey: .audioUrls)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(audioUrls, forKey: .audioUrls)
    }

    // MARK: - Equatable Conformance

    static func == (lhs: VoicedFeedback, rhs: VoicedFeedback) -> Bool {
        return lhs.title == rhs.title &&
               lhs.audioUrls == rhs.audioUrls
    }

    // MARK: - Hashable Conformance

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(audioUrls)
    }

    // Example of a cloning method if needed
    func clone(with audioUrls: [FeedbackSfx]) -> VoicedFeedback {
        return VoicedFeedback(title: self.title, audioUrls: audioUrls)
    }
}
