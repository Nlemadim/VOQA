//
//  QuizContext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation
import Combine

class QuizContext: ObservableObject {
    var state: QuizState
    var audioPlayer: AudioContentPlayer?
    var responseListener: ResponseListener?
    var quizModerator: QuizModerator?
    
    @Published var activeQuiz: Bool = false
    @Published var countdownTime: TimeInterval = 5.0 // Default countdown time
    @Published var responseTime: TimeInterval = 5.0 // Default response time
    @Published var isListening: Bool = false
    
    private var timer: Timer?
    
    init(state: QuizState) {
        self.state = state
    }
    
    func setState(_ state: QuizState) {
        self.state = state
        self.state.handleState(context: self)
    }
    
    func startQuiz() {
        activeQuiz = true
        startCountdown()
    }
    
    private func startCountdown() {
        timer?.invalidate()
        var remainingTime = countdownTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if remainingTime > 0 {
                remainingTime -= 1
                self.countdownTime = remainingTime
            } else {
                timer.invalidate()
                self.playFirstQuestion()
            }
        }
    }
    
    private func playFirstQuestion() {
        self.audioPlayer?.playCurrentQuestion()
    }
    
    func stopCountdown() {
        timer?.invalidate()
    }
}
