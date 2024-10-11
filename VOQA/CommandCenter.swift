//
//  CommandCenter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation

class CommandCenter {
    var session: QuizSession?
    private var config: QuizSessionConfig?
    
    init(session: QuizSession?) {
        self.session = session
    }
    
    func configure(with config: QuizSessionConfig) {
        self.config = config
        print("CommandCenter registers config \(config.sessionId)")
    }
    
    func setSessionQuestions() {
        guard let session = session, let config = config else { return }
        session.setState(session.questionPlayer)
        session.questionPlayer.setSessionQuestions(config.sessionQuestion)
    }
    
    // Start background music using the BgmPlayer
    func startBackgroundMusic() {
        guard let session = session else { return }
        print("Command Center: Starting background music.")
        session.bgmPlayer.playStartUpMusic()
        session.activeQuiz = true
    }
    
    func requestSeesionInfo() {
        //guard let session = session else { return }
        print("Command Center: Requesting Session info.")
        Task {
            await sessionInfoRequest()
        }
    }
    
    private func sessionInfoRequest() async {
        guard let session = session else { return }
        await session.dynamicContentManager.getSessionIntro()
    }
    
    var didFetchSessionInfo: Bool {
        guard let session = session else { return false }
        return session.dynamicContentManager.hasFetchedSessionIntro == true
    }
    
    func playHostIntro() {
        guard let session = session else { return }
        print("Command Center: Playing host intro.")
        let introAction = AudioAction.playHostIntro
        session.sessionAudioPlayer.performAudioAction(introAction)
        session.isNowPlaying = true
    }
    
    func playSessionIntro() {
        guard let session = session else { return }
        print("checking dynamic content manager status")
        if session.dynamicContentManager.hasFetchedSessionIntro {
            let sessionIntroAction = AudioAction.playSessionIntro
            session.sessionAudioPlayer.performAudioAction(sessionIntroAction)
            print("Command Center: Playing session intro.")
        }
    }
    
    func playFirstQuestion() {
        guard let session = session else { return }
        let questions = session.sessionInfo.sessionQuestions
        print("Command Center: Playing first question.")
        
        DispatchQueue.main.async {
            print("Ready to play \(questions.count) questions")
            session.questionPlayer.setSessionQuestions(questions)
            // Start the quiz timer
            self.startQuizTimer()
            
            session.questionPlayer.playCurrentQuestion()
        }
    }
    
    func awaitUserResponse() {
        guard let session = session else { return }
        DispatchQueue.main.async {
            session.isAwaitingResponse = true
        }
    }
    
    func displayQuestionText() {
        guard let session = session else { return }
        session.currentQuestionText = session.questionPlayer.currentQuestion?.content ?? ""
    }
    
    func confirmAnswer() {
        guard let session = session else { return }
        let audioAction = AudioAction.playCorrectAnswerCallout
        session.sessionAudioPlayer.performAudioAction(audioAction)
    }
    
    func rejectAnswer() {
        guard let session = session else { return }
        let audioAction = AudioAction.playWrongAnswerCallout
        session.sessionAudioPlayer.performAudioAction(audioAction)
    }
    
    func playCorrection() {
        guard let session = session else { return }
        let answerUrl = session.currentQuestion?.correctionAudioURL ?? ""
        let audioAction = AudioAction.playAnswer(url: answerUrl)
        session.sessionAudioPlayer.performAudioAction(audioAction)
    }
    
    func resumeQuiz() {
        guard let session = session else { return }
        guard session.questionPlayer.hasMoreQuestions else {
            print("No More Questions")
            print("Command Center requires continuation action")
            session.conductor.closeFlow()
            return
        }

        session.setState(session.questionPlayer)
        session.questionPlayer.prepareNextQuestion() // Changed to use protocol method
    }
    
    func prepareReview() {
        guard let session = session else { return }
        let prepareForReviewAction = AudioAction.prepareReview
        session.sessionAudioPlayer.performAudioAction(prepareForReviewAction)
    }
    
    func playSponsoredOutro() {
        guard let session = session else { return }
        let sponsoredOutroAction = AudioAction.sponsoredOutro
        session.sessionAudioPlayer.performAudioAction(sponsoredOutroAction)
    }
    
    private func getReview() {
        guard let session = session else { return }
        session.dynamicContentManager.fetchReview()
    }
    
    func playReview() {
        guard let session = session else { return }
        let dynamicReviewUrl = session.dynamicContentManager.dynamicReviewUrl
        print(dynamicReviewUrl)
        let testDynamicReview = "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_repeatQuestionScript.mp3"
        let audioAction = AudioAction.dynamicReview(url: testDynamicReview)
        session.sessionAudioPlayer.performAudioAction(audioAction)
    }
    
    func prepareToCloseSession() {
        guard let session = session else { return }
        let closingAction = AudioAction.playClosingRemarks
        session.sessionAudioPlayer.performAudioAction(closingAction)
    }
    
    func closeSession() {
        guard let session = session else { return }
        session.sessionCloser.performAction(.quitAndReset, session: session)
    }
    
    private func startQuizTimer() {
        guard let session = session else { return }
        session.quizTimer = 0.0
        session.quizStartTimer?.invalidate()
        session.quizStartTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard self != nil else { return }
            session.quizTimer += 1.0
        }
    }
    
    func pauseBgmPlayer() {
        guard let session = session else { return }
        session.bgmPlayer.pauseBackgroundMusic()
    }
}


