//
//  TestHomePageConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

//import Foundation
//
//// Creating topics
//let topic1 = Topic(topicTitle: "Linux", topicCategory: .intermediate, learningIndex: 3, questions: mockQuestions)
//
//let topic2 = Topic(topicTitle: "Google Cloud", topicCategory: .beginner, learningIndex: 2, questions: mockQuestions)
//
//let topic3 = Topic(topicTitle: "AWS", topicCategory: .advanced, learningIndex: 4, questions: mockQuestions)
//
//// Creating an audio quiz
//let audioQuiz = AudioQuiz(
//    quizTitle: "Sample Audio Quiz",
//    titleImage: "IconImage",
//    firstStarted: .now,
//    completions: 5,
//    userHighScore: 80,
//    ratings: 100,
//    currentQuizTopicIDs: [topic1.topicId.uuidString, topic2.topicId.uuidString],
//    topics: [topic1, topic2, topic3]
//)
//
//// Creating quiz packages
//let quizPackage1 = StandardQuizPackage(
//    id: UUID(),
//    title: "General Knowledge",
//    titleImage: "IconImage",
//    summaryDesc: "Test your general knowledge with this quiz package.",
//    topics: [topic1],
//    themeColors: [255, 0, 0],
//    rating: 4,
//    numberOfRatings: 100,
//    edition: .basic,
//    curator: "Quiz Master",
//    users: 1000,
//    audioQuiz: audioQuiz
//)
//
//let quizPackage2 = StandardQuizPackage(
//    id: UUID(),
//    title: "Science Quiz",
//    titleImage: "IconImage",
//    summaryDesc: "Explore the wonders of science.",
//    topics: [topic2],
//    themeColors: [0, 255, 0],
//    rating: 5,
//    numberOfRatings: 150,
//    edition: .curated,
//    curator: "Science Expert",
//    users: 500
//)
//
//let quizPackage3 = StandardQuizPackage(
//    id: UUID(),
//    title: "Chemistry Quiz",
//    titleImage: "IconImage",
//    summaryDesc: "Explore the wonders of science.",
//    topics: [topic2],
//    themeColors: [0, 255, 0],
//    rating: 5,
//    numberOfRatings: 150,
//    edition: .curated,
//    curator: "Science Expert",
//    users: 500
//)
//
//// Creating gallery items
//let galleryItem = GalleryItem(
//    title: "Featured Quizzes",
//    subtitle: "Top quizzes of the week",
//    quizzes: [quizPackage1, quizPackage2, quizPackage3]
//)
//
//let galleryItem2 = GalleryItem(
//    title: "Featured Quizzes",
//    subtitle: "Top quizzes of the week",
//    quizzes: [quizPackage1, quizPackage2, quizPackage3]
//)
//
//let galleryItem3 = GalleryItem(
//    title: "Featured Quizzes",
//    subtitle: "Top quizzes of the week",
//    quizzes: [quizPackage1, quizPackage2, quizPackage3]
//)
//// Creating HomePageConfig
//let homePageConfig = HomePageConfig(
//    topCollectionQuizzes: [quizPackage1, quizPackage2, quizPackage3],
//    nowPlaying: audioQuiz,
//    currentItem: 0,
//    backgroundImage: "VoqaIcon",
//    galleryItems: [galleryItem, galleryItem2, galleryItem3]
//)
//
//
//let mockQuestions: [Question] = [
//    Question(
//        topicId: UUID(),
//        content: "What is the capital of France?",
//        options: ["Paris", "London", "Berlin", "Madrid"],
//        correctOption: "D",
//        isAnsweredCorrectly: true,
//        numberOfPresentations: 1,
//        ratings: 5,
//        numberOfRatings: 100,
//        audioScript: "What is the capital of France?",
//        audioUrl: "smallVoiceOver.mp3",
//        replayQuestionAudioScript: "Can you repeat the question?",
//        replayOptionAudioScript: "Can you repeat the options?",
//        status: .newQuestion,
//        difficultyLevel: 1,
//        answerPresentedDate: Date()
//    ),
//    Question(
//        topicId: UUID(),
//        content: "What is the largest planet in our Solar System?",
//        options: ["Earth", "Mars", "Jupiter", "Saturn"],
//        correctOption: "B",
//        isAnsweredCorrectly: false,
//        numberOfPresentations: 2,
//        ratings: 4,
//        numberOfRatings: 50,
//        audioScript: "What is the largest planet in our Solar System?",
//        audioUrl: "smallVoiceOver2.mp3",
//        replayQuestionAudioScript: "Can you repeat the question?",
//        replayOptionAudioScript: "Can you repeat the options?",
//        status: .repeatQuestion,
//        difficultyLevel: 2,
//        answerPresentedDate: nil
//    ),
//    Question(
//        topicId: UUID(),
//        content: "What is the chemical symbol for water?",
//        options: ["H2O", "O2", "CO2", "H2"],
//        correctOption: "C",
//        isAnsweredCorrectly: true,
//        numberOfPresentations: 3,
//        ratings: 3,
//        numberOfRatings: 30,
//        audioScript: "What is the chemical symbol for water?",
//        audioUrl: "smallVoiceOver.mp3",
//        replayQuestionAudioScript: "Can you repeat the question?",
//        replayOptionAudioScript: "Can you repeat the options?",
//        status: .modifiedQuestion,
//        difficultyLevel: 1,
//        answerPresentedDate: Date()
//    ),
//    Question(
//        topicId: UUID(),
//        content: "Who wrote 'Romeo and Juliet'?",
//        options: ["William Shakespeare", "Charles Dickens", "Mark Twain", "Jane Austen"],
//        correctOption: "A",
//        isAnsweredCorrectly: false,
//        numberOfPresentations: 1,
//        ratings: 5,
//        numberOfRatings: 80,
//        audioScript: "Who wrote 'Romeo and Juliet'?",
//        audioUrl: "smallVoiceOver2.mp3",
//        replayQuestionAudioScript: "Can you repeat the question?",
//        replayOptionAudioScript: "Can you repeat the options?",
//        status: .followUp,
//        difficultyLevel: 2,
//        answerPresentedDate: nil
//    )
//]
