//
//  CommandCenter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation

class CommandCenter {
    var session: QuizSession?
    
    init(session: QuizSession?) {
        self.session = session
    }
    
    // Start background music using the BgmPlayer
    func startBackgroundMusic() {
        guard let session = session else { return }
        print("Command Center: Starting background music.")
        session.bgmPlayer.playStartUpMusic()
        session.activeQuiz = true
    }
    
    func playHostIntro() {
        guard let session = session else { return }
        print("Command Center: Playing host intro.")
        let introAction = AudioAction.playHostIntro
        session.sessionAudioPlayer.performAudioAction(introAction)
    }
    
    // new Methods
    func playSessionIntro() {
        guard let session = session else { return }
        print("Command Center: Playing session intro.")
        let sessionIntroAction = AudioAction.playSessionIntro
        session.sessionAudioPlayer.performAudioAction(sessionIntroAction)
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
    
    private func startQuizTimer() {
        guard let session = session else { return }
        session.quizTimer = 0.0
        session.quizStartTimer?.invalidate()
        session.quizStartTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard self != nil else { return }
            session.quizTimer += 1.0
        }
    }
    
    func resumeQuiz() {
        guard let session = session else { return }
        guard session.questionPlayer.hasMoreQuestions else {
            print("No More Questions")
            print("Command Center requires continuation action")
            //Commented out continuation logic for now
//            session.setState(session.reviewer)
//            session.reviewer.performAction(.giveScore, session: session)
            return
        }

        session.setState(session.questionPlayer)
        session.questionPlayer.prepareNextQuestion() // Changed to use protocol method
    }
}


