//
//  QuizOrchestra.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation

class Conductor: BgmPlayerDelegate, QuizServices, SessionObserver, SessionAudioPlayerDelegate {
    
    var observers: [SessionObserver] = []
    var commandCenter: CommandCenter
    var session: QuizSession?
    private var lastAction: AudioAction?

    init(commandCenter: CommandCenter) {
        self.commandCenter = commandCenter
        
    }

    // Orchestrate the start of the quiz, playing background music and voice intro
    func startFlow() {
        print("Orchestra: Starting quiz flow.")
        // Step 1: Load up questions
        commandCenter.setSessionQuestions()
        // Step 2: Start the background music
        commandCenter.startBackgroundMusic()
        // Step 3: Session Info request
        commandCenter.requestSeesionInfo()
        // Step 4: After a delay, play the voice intro
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            self.playHostIntro()
        }
    }

    // Play the voice intro
    private func playHostIntro() {
        print("Orchestra: Playing voice intro.")
        commandCenter.playHostIntro()
    }

    func conductNextAction() {
        guard let session = session else {  return }
           
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
            
            else if session.sessionAudioPlayer.lastAction == .playAnswer(url: session.currentQuestion?.correctionAudioURL ?? "") {
                print("Orchestra: Answer playback finished, moving to next action.")
                self.commandCenter.resumeQuiz()
            }
            
            else if session.sessionAudioPlayer.lastAction == .playCorrectAnswerCallout {
                print("Orchestra: Correct answer callout finished, moving to next action.")
                self.commandCenter.resumeQuiz()
            }
            
            // Ensure the queued actions are processed if there are any
            session.sessionAudioPlayer.completeCurrentAction()
        }
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
