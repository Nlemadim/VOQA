//
//  AudioPlayer+PlaybackControlExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Playback Control
    internal func playQuestions(_ questions: [Question]) {
        self.questions = questions
        context.activeQuiz = true
        playCurrentQuestion()
    }

    internal func playCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            print("No more questions to play.")
            context.setState(ReviewState(action: .reviewing))
            return
        }

        let question = questions[currentQuestionIndex]
        currentQuestionContent = question.content

        do {
            try startPlaybackFromBundle(fileName: question.audioUrl.deletingPathExtension, fileType: question.audioUrl.pathExtension)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The audio file for the question could not be found.")
        }
    }

    internal func skipToQuestion(withId id: UUID) {
        guard let index = questions.firstIndex(where: { $0.id == id }), index + 1 < questions.count else { return }
        currentQuestionIndex = index + 1
        playCurrentQuestion()
    }

    internal func stateManagedSkipToNextQuestion() {
        guard currentQuestionIndex + 1 < questions.count else { return }
        currentQuestionIndex += 1
        playCurrentQuestion()
    }
}
