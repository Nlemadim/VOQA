//
//  QuizState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//  All rights reserved.

import Foundation

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
