//
//  QuizOrchestra.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation
import Combine

class Conductor: BgmPlayerDelegate, QuizServices, SessionObserver, SessionAudioPlayerDelegate {
    
    var observers: [SessionObserver] = []
    var commandCenter: CommandCenter
    var session: QuizSession?
    private var lastAction: AudioAction?
    
    private var cancellables: Set<AnyCancellable> = []

    init(commandCenter: CommandCenter) {
        self.commandCenter = commandCenter
        
    }

    // Orchestrate the start of the quiz, playing background music and voice intro
    func startFlow() {
        print("Orchestra: Starting quiz flow.")
        // Step 1: Load up questions
        commandCenter.setSessionQuestions()
        
        // Step 2: Start the background music
       // commandCenter.startBackgroundMusic()
        
        // Step 3: Session Info request
       // commandCenter.requestSeesionInfo()
        
        // Step 4: After a delay, play the voice intro
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            self.session?.currentQuestionText = self.session?.questionPlayer.currentQuestion?.content ?? ""
            self.session?.isAwaitingResponse = true
            self.session?.isNowPlaying = true
          //  self.playHostIntro()
        }
    }
    
    func closeFlow() {
        print("Orchestra: closing quiz flow.")
        
        commandCenter.prepareReview()
        
    }

    // Play the voice intro
    private func playHostIntro() {
        print("Orchestra: Playing voice intro.")
        commandCenter.playHostIntro()
    }
    

    //Step 5
    func conductNextAction() {
        guard let session = session else { 
            print("Conductor guard blocked")
            return
        }
           
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            
            // Handle the last action and decide the next step
            if session.sessionAudioPlayer.lastAction == .playHostIntro {
                print("Conductor ordered session Intro")
                self.commandCenter.playSessionIntro()
            } 
            
            else if session.sessionAudioPlayer.lastAction == .playSessionIntro {
                print("Orchestra: Session intro finished, playing first question.")
                self.commandCenter.playFirstQuestion()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playQuestionAudioUrl(url: session.questionPlayer.currentQuestion?.questionScriptAudioURL ?? "") {
                print("Orchestra: Session intro finished, playing first question.")
                self.commandCenter.awaitUserResponse()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playCorrectAnswerCallout {
                print("Orchestra: Correct answer callout finished, moving to next action.")
                self.commandCenter.resumeQuiz()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playWrongAnswerCallout {
                print("Orchestra: Wrong answer callout finished, moving to next action.")
                self.commandCenter.playCorrection()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playAnswer(url: session.currentQuestion?.correctionAudioURL ?? "") {
                print("Orchestra: Correction playback finished, moving to next action.")
                self.commandCenter.resumeQuiz()
            }
            
            else if session.sessionAudioPlayer.lastAction == .prepareReview {
                print("Orchestra: prepare for review finished, moving to next action.")
                self.commandCenter.playSponsoredOutro()
            }
            
            else if session.sessionAudioPlayer.lastAction == .sponsoredOutro {
                print("Orchestra: Sponsored outro finished, moving to next action.")
                self.commandCenter.playReview()
            }
            
            else if session.sessionAudioPlayer.lastAction == .dynamicReview(url: session.dynamicContentManager.dynamicReviewUrl) {
                print("Orchestra: Review finished, moving to next action.")
                self.commandCenter.prepareToCloseSession()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playClosingRemarks {
                print("Orchestra: Review finished, moving to next action.")
                self.commandCenter.closeSession()
            }
            
            // Ensure the queued actions are processed if there are any
            session.sessionAudioPlayer.completeCurrentAction()
        }
    }
    
    private func setupObservers() {
        guard let session = session else { return }
        
        session.questionPlayer.$isPlayingQuestion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPlaying in
                guard let self = self else { return }
                if isPlaying {
                    self.commandCenter.displayQuestionText()
                }
            }
            .store(in: &cancellables)
        
        session.scoreRegistry.$playCorrection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playCorrection in
                guard let self = self else { return }
                if playCorrection {
                    self.commandCenter.playCorrection()
                }
            }
            .store(in: &cancellables)
        
        
      //MARK: TODO check State of Score Registry for next action
       
    }



    // MARK: - BgmPlayerDelegate
    func bgmPlayerDidFinishPlaying(_ player: BgmPlayer) {
        print("Orchestra: Background music finished. Moving to next action.")
        session?.isNowPlaying = false
    }

    // MARK: - SessionAudioPlayerDelegate
    func sessionAudioPlayerDidFinishPlaying(_ player: SessionAudioPlayer) {
        print("Orchestra: Session audio finished playing.")
        conductNextAction() // This can control the next action in the flow based on what just finished
    }
    
    func handleState(session: QuizSession) {
        
    }
    
    func addObserver(_ observer: any SessionObserver) {
        
    }
    
    func notifyObservers() {
    
    }
    
    func stateDidChange(to newState: any QuizServices) {
        
    }
}





/***
 
 
//                // Check if the session intro has been fetched
//                if session.sessionInfo.dynamicSessionInfo != nil {
//                    print("Orchestra: Session intro fetched, playing session intro.")
//                    self.commandCenter.playSessionIntro()
//                } else {
//                    self.commandCenter.playFirstQuestion()
//                    print("Orchestra: Session intro not fetched yet, skipping this action or proceeding with another.")
//                    // You can either skip this step or decide to trigger another action
//                    // For now, just log and continue
//                }
 
 */
