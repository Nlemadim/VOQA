//
//  TestConfigurationBuilder.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

//MARK: Test Environment Config Generation
class TestConfigurationBuilder {
    let networkService = NetworkService()
    
    func createControlFeedbackModels() -> ControlsFeedback {
        return ControlsFeedback(
            startQuiz: StartQuizFeedback(title: "Start Quiz", audioUrls: [
                FeedbackSfx(title: "start1", urlScript: "Let's get started", audioUrl: ""),
                FeedbackSfx(title: "start2", urlScript: "Ready to begin? Let's go", audioUrl: ""),
                FeedbackSfx(title: "start3", urlScript: "Here we go, good luck", audioUrl: "")
            ]),
            quit: QuitQuiz(title: "Quit Quiz", audioUrls: [
                FeedbackSfx(title: "quit1", urlScript: "The quiz will now end", audioUrl: ""),
                FeedbackSfx(title: "quit2", urlScript: "You have chosen to quit the quiz", audioUrl: ""),
                FeedbackSfx(title: "quit3", urlScript: "Review will follow", audioUrl: "")
            ]),
            nextQuestion: NextQuestion(title: "Next Question", audioUrls: [
                FeedbackSfx(title: "next1", urlScript: "Let's move to the next question", audioUrl: ""),
                FeedbackSfx(title: "next2", urlScript: "Next up, please", audioUrl: ""),
                FeedbackSfx(title: "next3", urlScript: "On to the next one", audioUrl: "")
            ]),
            repeatQuestioon: RepeatQuestion(title: "Repeat Question", audioUrls: [
                FeedbackSfx(title: "repeat1", urlScript: "I'll repeat the question", audioUrl: ""),
                FeedbackSfx(title: "repeat2", urlScript: "Let's hear that question again", audioUrl: ""),
                FeedbackSfx(title: "repeat3", urlScript: "One more time, here it is", audioUrl: "")
            ])
        )
    }

    func createQuizFeedbackModels() -> QuizFeedback {
        return QuizFeedback(
            incorrectAnswer: IncorrectAnswerFeedback(title: "Incorrect Answer", audioUrls: [
                FeedbackSfx(title: "incorrect1", urlScript: "Sorry, that's not correct", audioUrl: ""),
                FeedbackSfx(title: "incorrect2", urlScript: "That's not right, try again", audioUrl: ""),
                FeedbackSfx(title: "incorrect3", urlScript: "Oops, that's not it", audioUrl: "")
            ]),
            correctAnswer: CorrectAnswerFeedback(title: "Correct Answer", audioUrls: [
                FeedbackSfx(title: "correct1", urlScript: "Nice! That's the right answer", audioUrl: ""),
                FeedbackSfx(title: "correct2", urlScript: "That is correct", audioUrl: ""),
                FeedbackSfx(title: "correct3", urlScript: "Well done, that's right", audioUrl: "")
            ]),
            noResponse: NoResponseFeedback(title: "No Response", audioUrls: [
                FeedbackSfx(title: "noResponse1", urlScript: "It seems you didn't respond", audioUrl: ""),
                FeedbackSfx(title: "noResponse2", urlScript: "No answer detected, please try", audioUrl: ""),
                FeedbackSfx(title: "noResponse3", urlScript: "Please give an answer next time", audioUrl: "")
            ])
        )
    }

    func populateAudioUrls<T: VoicedFeedback>(for feedback: T) async throws -> T {
        var populatedFeedback = feedback
        populatedFeedback.audioUrls = try await self.populateFeedbackSfx(feedback.audioUrls)
        return populatedFeedback
    }
    
    private func populateFeedbackSfx(_ feedbackSfx: [FeedbackSfx]) async throws -> [FeedbackSfx] {
        return try await withThrowingTaskGroup(of: FeedbackSfx.self) { group in
            var results: [FeedbackSfx] = []
            
            for sfx in feedbackSfx {
                group.addTask {
                    print("Fetching URL for feedback message: \(sfx.urlScript)")
                    var updatedSfx = sfx
                    updatedSfx.audioUrl = try await self.networkService.fetchAudioUrl(for: updatedSfx.urlScript)
                    print("Fetched URL for message '\(sfx.urlScript)': \(updatedSfx.audioUrl)")
                    return updatedSfx
                }
            }
            
            for try await result in group {
                results.append(result)
            }
            
            return results
        }
    }
    
    func printUrls(for controlFeedback: ControlsFeedback) {
        print("current question ID: nil")
        print("Control Feedback URLs:")
        printUrls(from: controlFeedback.startQuiz.audioUrls, title: "Start Quiz")
        printUrls(from: controlFeedback.quit.audioUrls, title: "Quit")
        printUrls(from: controlFeedback.nextQuestion.audioUrls, title: "Next Question")
        printUrls(from: controlFeedback.repeatQuestioon.audioUrls, title: "Repeat Question")
    }

    func printUrls(for quizFeedback: QuizFeedback) {
        print("Quiz Feedback URLs:")
        printUrls(from: quizFeedback.incorrectAnswer.audioUrls, title: "Incorrect Answer")
        printUrls(from: quizFeedback.correctAnswer.audioUrls, title: "Correct Answer")
        printUrls(from: quizFeedback.noResponse.audioUrls, title: "No Response")
    }
    
    private func printUrls(from audioUrls: [FeedbackSfx], title: String) {
        print("\(title):")
        for sfx in audioUrls {
            print("  - \(sfx.urlScript): \(sfx.audioUrl)")
        }
    }
}
