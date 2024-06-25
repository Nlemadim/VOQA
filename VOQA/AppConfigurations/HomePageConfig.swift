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
    var quizzes: [QuizPackageProtocol]
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case quizzes
    }
    
    init(title: String, subtitle: String? = nil, quizzes: [QuizPackageProtocol]) {
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

struct HomePageConfig: Decodable {
    var topCollectionQuizzes: [QuizPackageProtocol]
    var nowPlaying: AudioQuizProtocol?
    var currentItem: Int
    var backgroundImage: String
    var galleryItems: [GalleryItem]
    
    enum CodingKeys: String, CodingKey {
        case topCollectionQuizzes
        case nowPlaying
        case currentItem
        case backgroundImage
        case galleryItems
    }
    
    init(topCollectionQuizzes: [QuizPackageProtocol], nowPlaying: AudioQuizProtocol?, currentItem: Int, backgroundImage: String, galleryItems: [GalleryItem]) {
        self.topCollectionQuizzes = topCollectionQuizzes
        self.nowPlaying = nowPlaying
        self.currentItem = currentItem
        self.backgroundImage = backgroundImage
        self.galleryItems = galleryItems
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let quizPackages = try container.decode([StandardQuizPackage].self, forKey: .topCollectionQuizzes)
        topCollectionQuizzes = quizPackages
        nowPlaying = try container.decodeIfPresent(AudioQuiz.self, forKey: .nowPlaying)
        currentItem = try container.decode(Int.self, forKey: .currentItem)
        backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
        galleryItems = try container.decode([GalleryItem].self, forKey: .galleryItems)
    }
}
