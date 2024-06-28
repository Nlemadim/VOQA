//
//  HomePageConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

struct GalleryItem: Decodable {
    var title: String
    var subtitle: String?
    var quizzes: [StandardQuizPackage]
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case quizzes
    }
    
    init(title: String, subtitle: String? = nil, quizzes: [StandardQuizPackage]) {
        self.title = title
        self.subtitle = subtitle
        self.quizzes = quizzes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        let quizPackages = try container.decode([StandardQuizPackage].self, forKey: .quizzes)
        quizzes = quizPackages
    }
}

struct HomePageConfig {
    var topCollectionQuizzes: [PacketCover]
    var currentItem: Int
    var backgroundImage: String
    var galleryItems: [PacketCover]
    
    static func create() -> HomePageConfig {
        let packetCover1 = PacketCover(
            id: UUID(),
            title: "General Knowledge",
            titleImage: "IconImage",
            summaryDesc: "Test your general knowledge with this quiz package.",
            rating: 4,
            numberOfRatings: 100,
            edition: "basic",
            curator: "Quiz Master",
            users: 1000
        )

        let packetCover2 = PacketCover(
            id: UUID(),
            title: "Science Quiz",
            titleImage: "IconImage",
            summaryDesc: "Explore the wonders of science.",
            rating: 5,
            numberOfRatings: 150,
            edition: "curated",
            curator: "Science Expert",
            users: 500
        )

        let packetCover3 = PacketCover(
            id: UUID(),
            title: "Chemistry Quiz",
            titleImage: "IconImage",
            summaryDesc: "Dive into the world of chemistry.",
            rating: 5,
            numberOfRatings: 150,
            edition: "curated",
            curator: "Chemistry Expert",
            users: 500
        )

        let packetCover4 = PacketCover(
            id: UUID(),
            title: "History Quiz",
            titleImage: "IconImage",
            summaryDesc: "Explore the events of the past.",
            rating: 4,
            numberOfRatings: 120,
            edition: "curated",
            curator: "History Expert",
            users: 450
        )

        let packetCover5 = PacketCover(
            id: UUID(),
            title: "Math Quiz",
            titleImage: "IconImage",
            summaryDesc: "Test your mathematics skills.",
            rating: 5,
            numberOfRatings: 200,
            edition: "basic",
            curator: "Math Guru",
            users: 700
        )

        return HomePageConfig(
            topCollectionQuizzes: [packetCover1, packetCover2, packetCover3],
            currentItem: 0,
            backgroundImage: "VoqaIcon",
            galleryItems: [packetCover1, packetCover2, packetCover3, packetCover4, packetCover5]
        )
    }
}
