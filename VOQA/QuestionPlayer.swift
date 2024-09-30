//
//  QuestionPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/26/24.
//

import Foundation
import Combine
import AVFoundation

/// Protocol defining the essential functionalities of a `QuestionPlayer`.
protocol QuestionPlayerProtocol: AnyObject {
    /// The delegate to receive updates.
    var delegate: (any QuestionPlayerDelegate)? { get set }
    
    /// Sets the questions for the session.
    func setSessionQuestions(_ questions: [any QuestionType])
    
    /// Plays the current question.
    func playCurrentQuestion()
    
    /// Prepares and plays the next question.
    func prepareNextQuestion()
    
    /// Replays the current question's audio narration.
    func replayQuestion()
    
    /// Stops playback and resets the player.
    func stopPlayback()
    
    /// Resets the current question index to the beginning.
    func resetQuestionIndex()
}

/// A delegate protocol for receiving updates from `QuestionPlayer`.
protocol QuestionPlayerDelegate: AnyObject {
    /// Called when the current question is updated.
    func questionPlayer(_ player: QuestionPlayerProtocol, didUpdateQuestion question: (any QuestionType)?)
    
    /// Called when the `QuestionPlayer` has finished playing all questions.
    func questionPlayerDidFinish(_ player: QuestionPlayerProtocol)
}

/// The `QuestionPlayer` class responsible for managing question playback.
class QuestionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, SessionObserver, QuizServices, QuestionPlayerProtocol {
    
    /// An enumeration of actions that `QuestionPlayer` can perform.
    enum QuestionPlayerAction {
        case setSessionQuestions([any QuestionType])
        case playCurrentQuestion(any QuestionType)
        case prepareNextQuestion
        case replayQuestion
    }
    
    // MARK: - Published Properties
    
    /// Indicates whether a question is currently being played.
    @Published private(set) var isPlayingQuestion: Bool = false
    
    /// Indicates whether there are more questions to play.
    @Published private(set) var hasMoreQuestions: Bool = false
    
    /// The index of the current question being played.
    @Published private(set) var currentQuestionIndex: Int = 0
    
    /// The identifier of the current question.
    @Published private(set) var currentQuestionId: String?
    
    /// The current question being played.
    @Published private(set) var currentQuestion: (any QuestionType)?
    
    // MARK: - Private Properties
    
    /// The list of questions for the current session.
    private var currentQuestions: [any QuestionType] = []
    
    /// The current action to be performed.
    private var action: QuestionPlayerAction?
    
    /// Observers for session state changes.
    var observers: [SessionObserver] = []
    
    /// Reference to the current quiz session.
    weak var session: QuizSession?
    
    // MARK: - Delegate Property
    
    /// The delegate to receive updates.
    weak var delegate: (any QuestionPlayerDelegate)?
    
    // MARK: - Initializer
    
    /// Initializes the `QuestionPlayer` with an optional initial action.
    /// - Parameter action: The initial action to perform.
    init(action: QuestionPlayerAction? = nil) {
        self.action = action
        super.init()
    }
    
    // MARK: - QuizServices Protocol Methods
    
    /// Handles the current state by performing the pending action if any.
    /// - Parameter session: The current quiz session.
    func handleState(session: QuizSession) {
        print("QuestionPlayer handleState called")
        
        if let action = self.action {
            performAction(action, session: session)
        }
    }
    
    /// Adds an observer to the session.
    /// - Parameter observer: The observer to add.
    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }
    
    /// Notifies all observers about the state change.
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
    
    // MARK: - SessionObserver Protocol Method
    
    /// Handles state changes.
    /// - Parameter newState: The new state to handle.
    func stateDidChange(to newState: QuizServices) {
        print("Question Player state did change to \(type(of: newState))")
        // Handle state changes if needed
    }
    
    // MARK: - QuestionPlayerProtocol Methods
    
    /// Sets the questions for the session.
    /// - Parameter questions: An array of questions conforming to `any QuestionType`.
    func setSessionQuestions(_ questions: [any QuestionType]) {
        guard let session = self.session else {
            print("No active session to set questions.")
            return
        }
        performAction(.setSessionQuestions(questions), session: session)
    }
    
    /// Plays the current question.
    func playCurrentQuestion() {
        guard let session = self.session else {
            print("No active session to play question.")
            return
        }
        performAction(.playCurrentQuestion(currentQuestion!), session: session)
    }
    
    /// Prepares and plays the next question.
    func prepareNextQuestion() {
        guard let session = self.session else {
            print("No active session to prepare next question.")
            return
        }
        performAction(.prepareNextQuestion, session: session)
    }
    
    /// Replays the current question's audio narration.
    func replayQuestion() {
        guard let session = self.session else {
            print("No active session to replay question.")
            return
        }
        performAction(.replayQuestion, session: session)
    }
    
    /// Stops playback and resets the player.
    func stopPlayback() {
        // Implement the logic to stop playback and reset the player.
        // Example:
        self.isPlayingQuestion = false
        self.hasMoreQuestions = false
        self.currentQuestionIndex = 0
        self.currentQuestionId = nil
        self.currentQuestion = nil
        self.currentQuestions = []
        print("Playback stopped and player reset.")
    }
    
    // MARK: - Action Handling
    
    /// Performs the given action within the context of the session.
    /// - Parameters:
    ///   - action: The action to perform.
    ///   - session: The current quiz session.
    func performAction(_ action: QuestionPlayerAction, session: QuizSession) {
        print("QuestionPlayer performAction called with action: \(action)")
        print("Current Question Index: \(currentQuestionIndex)")
        print("Total Questions: \(currentQuestions.count)")
        
        switch action {
            
        case .setSessionQuestions(let questions):
            loadQuestions(questions: questions, session: session)
            
        case .playCurrentQuestion(let question):
            playQuestion(question: question, session: session)
            
        case .prepareNextQuestion:
            prepareNextQuestion(session: session)
            
        case .replayQuestion:
            replayQuestion(session: session)
        }
    }
    
    /// Loads the questions into the player and starts playing the first one.
    /// - Parameters:
    ///   - questions: An array of questions conforming to `any QuestionType`.
    ///   - session: The current quiz session.
    private func loadQuestions(questions: [any QuestionType], session: QuizSession) {
        guard !questions.isEmpty else {
            print("Questions Unavailable")
            return
        }
        
        self.currentQuestions = questions
        self.currentQuestionIndex = 0
        let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
        self.currentQuestion = currentQuestion
        self.currentQuestionId = currentQuestion.id
        
        performAction(.playCurrentQuestion(currentQuestion), session: session)
    }
    
    /// Plays the given question.
    /// - Parameters:
    ///   - question: The question to play.
    ///   - session: The current quiz session.
    private func playQuestion(question: any QuestionType, session: QuizSession) {
        setUpCurrentQuestion(session: session, question: question)
        session.currentQuestionText = question.repeatQuestionScript
        updateHasNextQuestion()
        
        startPlayback(session: session)
    }
    
    /// Sets up the current question in the session.
    /// - Parameters:
    ///   - session: The current quiz session.
    ///   - question: The current question to set.
    private func setUpCurrentQuestion(session: QuizSession, question: any QuestionType) {
        // Since 'currentQuestion' is already set, no need for casting
        session.updateQuestionCounter(questionIndex: currentQuestionIndex, count: currentQuestions.count)
        
        self.currentQuestion = question
        self.currentQuestionId = question.id
    }
    
    /// Updates the flag indicating if there are more questions to play.
    private func updateHasNextQuestion() {
        hasMoreQuestions = currentQuestionIndex < currentQuestions.count - 1
        if let session = session {
            if currentQuestionIndex == currentQuestions.count - 1 {
                DispatchQueue.main.async {
                    session.hasAskedLastQuestion = true
                }
            }
        }
    }
    
    /// Starts playback of the current question's audio.
    /// - Parameter session: The current quiz session.
    private func startPlayback(session: QuizSession) {
        // Ensure currentQuestionIndex is within bounds
        guard currentQuestionIndex < currentQuestions.count else {
            print("Error: currentQuestionIndex \(currentQuestionIndex) is out of bounds.")
            return
        }
        
        let question = currentQuestions[currentQuestionIndex]
        
        // Assuming session.sessionAudioPlayer handles audio playback
        session.sessionAudioPlayer.setContext(session)
        session.sessionAudioPlayer.performAudioAction(.playQuestionAudioUrl(url: question.audioURL ?? ""))
        session.setState(session.questionPlayer)
        
        self.isPlayingQuestion = true
    }
    
    /// Prepares and plays the next question.
    /// - Parameter session: The current quiz session.
    private func prepareNextQuestion(session: QuizSession) {
        //let currentIndex = self.currentQuestionIndex
        session.currentQuestionText = "Next Question"
        self.currentQuestionIndex += 1
        guard self.currentQuestionIndex < currentQuestions.count else {
            // No more questions to prepare
            self.hasMoreQuestions = false
            delegate?.questionPlayerDidFinish(self)
            return
        }
        let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
        self.currentQuestion = currentQuestion
        self.currentQuestionId = currentQuestion.id
        
        performAction(.playCurrentQuestion(currentQuestion), session: session)
    }
    
    /// Replays the current question's audio narration.
    /// - Parameter session: The current quiz session.
    private func replayQuestion(session: QuizSession) {
        // Ensure currentQuestionIndex is within bounds
        guard currentQuestionIndex < currentQuestions.count else {
            print("Error: currentQuestionIndex \(currentQuestionIndex) is out of bounds.")
            return
        }
        
        let question = currentQuestions[currentQuestionIndex]
        
        session.sessionAudioPlayer.performAudioAction(.playQuestionAudioUrl(url: question.audioURL ?? ""))
        
        // Optionally, you can reset the playback state
        self.isPlayingQuestion = true
    }
    
    /// Resets the current question index to the beginning.
    func resetQuestionIndex() {
        self.currentQuestionIndex = 0
    }
}
