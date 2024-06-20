//
//  QuizState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//  All rights reserved.

import Foundation


/// Protocol representing a state in the quiz.
protocol QuizState {
    var observers: [StateObserver] { get set }
    
    /// Handles the logic associated with this state.
    func handleState(context: QuizContext)
    
    /// Adds an observer to the state.
    func addObserver(_ observer: StateObserver)
    
    /// Notifies all observers about the state change.
    func notifyObservers()
}

protocol StateObserver: AnyObject {
    func stateDidChange(to newState: QuizState)
}

class QuizContext {
    var state: QuizState
    var audioPlayer: AudioContentPlayer?
    var responseListener: ResponseListener?
    var quizModerator: QuizModerator?

    init(state: QuizState, audioPlayer: AudioContentPlayer? = nil, responseListener: ResponseListener? = nil, quizModerator: QuizModerator? = nil) {
        self.state = state
        self.audioPlayer = audioPlayer
        self.responseListener = responseListener
        self.quizModerator = quizModerator
    }

    func setState(_ state: QuizState) {
        self.state = state
        self.state.handleState(context: self)
    }
}
/// Base class for all states in the quiz.
class BaseState: QuizState {
    var observers = [StateObserver]()
    
    func handleState(context: QuizContext) {
        // Default implementation
    }
    
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
}

/// State representing the idle state of the quiz.
class IdleState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle idle state logic
        notifyObservers()
    }
}

/// State representing the started quiz state of the quiz.
class StartedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle started quiz logic
        notifyObservers()
    }
}

/// State representing the countdown state of the quiz.
class CountdownState: BaseState {
    enum CountdownType {
        case quizStart
        case responseTimer
    }
    
    var type: CountdownType
    
    init(type: CountdownType) {
        self.type = type
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .quizStart:
            // Handle quiz start countdown logic
            break
        case .responseTimer:
            // Handle response timer countdown logic
            break
        }
        notifyObservers()
    }
}

/// State representing the downloading state of the quiz.
class DownloadingState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle downloading state logic
        notifyObservers()
    }
}

/// State representing the finished downloading state of the quiz.
class FinishedDownloadingState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle finished downloading state logic
        notifyObservers()
    }
}

/// State representing the listening state of the quiz.

class ListeningState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle listening state logic
        notifyObservers()
    }
}

/// State representing the awaiting response state of the quiz.
class AwaitingResponseState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle awaiting response state logic
        notifyObservers()
    }
}

/// State representing the processing state of the quiz.
class ProcessingState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle processing state logic
        notifyObservers()
    }
}

/// State representing the response-related state of the quiz.
class ResponseState: BaseState {
    enum ResponseType {
        case hasResponded
        case noResponse
        case errorResponse
        case successfulResponse
        case errorTranscription
        case successfulTranscription
        case correctAnswer
        case incorrectAnswer
    }
    
    var type: ResponseType
    
    init(type: ResponseType) {
        self.type = type
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .hasResponded:
            // Handle has responded logic
            break
        case .noResponse:
            // Handle no response logic
            context.setState(FeedbackMessageState(type: .noResponse))
        case .errorResponse:
            // Handle error response logic
            break
        case .successfulResponse:
            // Handle successful response logic
            break
        case .errorTranscription:
            // Handle error transcription logic
            context.setState(FeedbackMessageState(type: .transcriptionError))
        case .successfulTranscription:
            // Handle successful transcription logic
            break
        case .correctAnswer:
            // Handle correct answer logic
            context.setState(FeedbackMessageState(type: .correctAnswer))
        case .incorrectAnswer:
            // Handle incorrect answer logic
            context.setState(FeedbackMessageState(type: .incorrectAnswer))
        }
        notifyObservers()
    }
}

/// State representing the feedback message state of the quiz.
class FeedbackMessageState: BaseState {
    enum FeedbackType {
        case correctAnswer
        case incorrectAnswer
        case noResponse
        case transcriptionError
    }
    
    var type: FeedbackType
    
    init(type: FeedbackType) {
        self.type = type
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .correctAnswer:
            // Handle playing correct answer feedback message logic
            playFeedbackAudio("correct_answer.mp3")
        case .incorrectAnswer:
            // Handle playing incorrect answer feedback message logic
            playFeedbackAudio("incorrect_answer.mp3")
        case .noResponse:
            // Handle playing no response feedback message logic
            playFeedbackAudio("no_response.mp3")
        case .transcriptionError:
            // Handle playing transcription error feedback message logic
            playFeedbackAudio("transcription_error.mp3")
        }
        notifyObservers()
    }
    
    private func playFeedbackAudio(_ fileName: String) {
        // Logic to play the audio file
    }
}

/// State representing the review state of the quiz.
class ReviewState: BaseState {
    enum ReviewAction {
        case reviewing
        case doneReviewing
    }
    
    var action: ReviewAction
    
    init(action: ReviewAction) {
        self.action = action
    }
    
    override func handleState(context: QuizContext) {
        switch action {
        case .reviewing:
            // Handle reviewing logic
            break
        case .doneReviewing:
            // Handle done reviewing logic
            break
        }
        notifyObservers()
    }
}

/// State representing the error message state of the quiz.
class ErrorMessageState: BaseState {
    enum ErrorMessageType {
        case playing
        case donePlaying
    }
    
    var type: ErrorMessageType
    
    init(type: ErrorMessageType) {
        self.type = type
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .playing:
            // Handle playing error message logic
            break
        case .donePlaying:
            // Handle done playing error message logic
            break
        }
        notifyObservers()
    }
}
