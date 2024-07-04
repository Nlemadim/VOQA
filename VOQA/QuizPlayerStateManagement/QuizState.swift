//
//  QuizState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//  All rights reserved.

import Foundation

<<<<<<< HEAD

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
=======
>>>>>>> 28edd9609007f43fd3fdbfa1cc9236f509b2ea7b
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

<<<<<<< HEAD
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
=======
>>>>>>> 28edd9609007f43fd3fdbfa1cc9236f509b2ea7b

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

/// State representing the started quiz state of the quiz.
class StartedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle started quiz logic
        notifyObservers()
    }
}

<<<<<<< HEAD
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
    
=======
/// State representing the started quiz state of the quiz.
class EndedQuizState: BaseState {
>>>>>>> 28edd9609007f43fd3fdbfa1cc9236f509b2ea7b
    override func handleState(context: QuizContext) {
        context.activeQuiz = false
        // Handle any additional logic for ending the quiz, such as reloading questions for future implementation
        notifyObservers()
    }
}


