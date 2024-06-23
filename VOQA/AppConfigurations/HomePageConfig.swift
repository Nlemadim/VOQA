//
//  HomePageConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

struct GalleryItem {
    var title: String
    var subtitle: String?
    var quizzes: [QuizPackageProtocol]
}

struct HomePageConfig {
    var topCollectionQuizzes: [QuizPackageProtocol]
    var nowPlaying: AudioQuizProtocol?
    var currentItem: Int
    var backgroundImage: String
    var galleryItems: [GalleryItem]
    
    init(topCollectionQuizzes: [QuizPackageProtocol], nowPlaying: AudioQuizProtocol?, currentItem: Int, backgroundImage: String, galleryItems: [GalleryItem]) {
        self.topCollectionQuizzes = topCollectionQuizzes
        self.nowPlaying = nowPlaying
        self.currentItem = currentItem
        self.backgroundImage = backgroundImage
        self.galleryItems = galleryItems
    }
}
