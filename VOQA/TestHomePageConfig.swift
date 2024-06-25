//
//  TestHomePageConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

// Creating topics
let topic1 = Topic(topicId: UUID(), topicTitle: "Math", topicCategory: .advanced, learningIndex: 5, presentations: 2)
let topic2 = Topic(topicId: UUID(), topicTitle: "History", topicCategory: .advanced, learningIndex: 7, presentations: 3)

// Creating an audio quiz
let audioQuiz = AudioQuiz(
    quizTitle: "Sample Audio Quiz",
    titleImage: "IconImage",
    firstStarted: .now,
    completions: 5,
    userHighScore: 80,
    ratings: 100,
    currentQuizTopicIDs: [topic1.topicId.uuidString, topic2.topicId.uuidString],
    topics: [topic1, topic2]
)

// Creating quiz packages
let quizPackage1 = StandardQuizPackage(
    id: UUID(),
    title: "General Knowledge",
    titleImage: "IconImage",
    summaryDesc: "Test your general knowledge with this quiz package.",
    topics: [topic1],
    themeColors: [255, 0, 0],
    rating: 4,
    numberOfRatings: 100,
    edition: .basic,
    curator: "Quiz Master",
    users: 1000,
    audioQuiz: audioQuiz
)

let quizPackage2 = StandardQuizPackage(
    id: UUID(),
    title: "Science Quiz",
    titleImage: "IconImage",
    summaryDesc: "Explore the wonders of science.",
    topics: [topic2],
    themeColors: [0, 255, 0],
    rating: 5,
    numberOfRatings: 150,
    edition: .curated,
    curator: "Science Expert",
    users: 500
)

let quizPackage3 = StandardQuizPackage(
    id: UUID(),
    title: "Chemistry Quiz",
    titleImage: "IconImage",
    summaryDesc: "Explore the wonders of science.",
    topics: [topic2],
    themeColors: [0, 255, 0],
    rating: 5,
    numberOfRatings: 150,
    edition: .curated,
    curator: "Science Expert",
    users: 500
)

// Creating gallery items
let galleryItem = GalleryItem(
    title: "Featured Quizzes",
    subtitle: "Top quizzes of the week",
    quizzes: [quizPackage1, quizPackage2, quizPackage3]
)

let galleryItem2 = GalleryItem(
    title: "Featured Quizzes",
    subtitle: "Top quizzes of the week",
    quizzes: [quizPackage1, quizPackage2, quizPackage3]
)

let galleryItem3 = GalleryItem(
    title: "Featured Quizzes",
    subtitle: "Top quizzes of the week",
    quizzes: [quizPackage1, quizPackage2, quizPackage3]
)
// Creating HomePageConfig
let homePageConfig = HomePageConfig(
    topCollectionQuizzes: [quizPackage1, quizPackage2, quizPackage3],
    nowPlaying: audioQuiz,
    currentItem: 0,
    backgroundImage: "VoqaIcon",
    galleryItems: [galleryItem, galleryItem2, galleryItem3]
)
