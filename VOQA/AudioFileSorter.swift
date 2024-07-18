//
//  AudioFileSorter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

class AudioFileSorter {
    private var config: QuizSessionConfig?
    private var randomGenerator: RandomNumberGenerator
    
    init(randomGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomGenerator = randomGenerator
    }
    
    func configure(with config: QuizSessionConfig) {
        self.config = config
    }
    
    func getAudioFile(for action: AudioAction) -> URL? {
        guard let config = config else {
            print("Configuration is not set")
            return nil
        }
        
        var audioUrls: [String] = []
        
        switch action {
        case .playCorrectAnswerCallout:
            audioUrls = config.quizFeedback.correctAnswer.audioUrls.compactMap { $0.audioUrl }
            print("Action: playCorrectAnswerCallout, Audio URLs: \(audioUrls)")
        case .playWrongAnswerCallout:
            audioUrls = config.quizFeedback.incorrectAnswer.audioUrls.compactMap { $0.audioUrl }
            print("Action: playWrongAnswerCallout, Audio URLs: \(audioUrls)")
        case .playNoResponseCallout:
            audioUrls = config.quizFeedback.noResponse.audioUrls.compactMap { $0.audioUrl }
            print("Action: playNoResponseCallout, Audio URLs: \(audioUrls)")
        case .waitingForResponse:
            audioUrls = config.alerts.filter { $0.urlScript == "Responder" }.compactMap { $0.audioUrl }
            print("Action: waitingForResponse, Audio URLs: \(audioUrls)")
        case .receivedResponse:
            audioUrls = config.alerts.filter { $0.urlScript == "Dismiss Responder" }.compactMap { $0.audioUrl }
            print("Action: receivedResponse, Audio URLs: \(audioUrls)")
        case .nextQuestion:
            audioUrls = config.controlFeedback.nextQuestion.audioUrls.compactMap { $0.audioUrl }
            print("Action: nextQuestion, Audio URLs: \(audioUrls)")
        case .reviewing:
            audioUrls = config.sessionMusic.compactMap { $0.audioUrl }
            print("Action: reviewing, Audio URLs: \(audioUrls)")
        case .playQuestionAudioUrl(let url), .playAnswer(let url), .playFeedbackMessage(let url):
            print("Action: \(action), URL: \(url)")
            return URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        case .pausePlay, .reset:
            print("Action: \(action), No URL needed")
            return nil
        case .playBGM:
            audioUrls = config.sessionMusic.compactMap { $0.audioUrl }
            return nil
       
        case .giveScore(score: let score):
            let url = getScorePlaybackUrl(score: score, config: config)
            audioUrls.append(url)
        }
        
        guard !audioUrls.isEmpty else {
            print("No audio URLs found for action: \(action)")
            return nil
        }
        
        let randomIndex = Int.random(in: 0..<audioUrls.count, using: &randomGenerator)
        let selectedUrl = audioUrls[randomIndex]
        print("Selected URL for action \(action): \(selectedUrl)")
        return URL(string: selectedUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    func getScorePlaybackUrl(score: Int, config: QuizSessionConfig) -> String {
        var currentScoreUrl: String = ""
        let scoreUrls = config.quizFeedback.giveScore.audioUrls

        // Iterate over the scoreUrls
        for scoreUrl in scoreUrls {
            // Extract the integer value from the title of the scoreUrl
            if let titleScore = Int(scoreUrl.title) {
                // Check if the titleScore matches the provided score
                if titleScore == score {
                    // If it matches, assign the scoreUrl to currentScoreUrl
                    currentScoreUrl = scoreUrl.audioUrl
                    break
                }
            }
        }

        // Return the currentScoreUrl
        return currentScoreUrl
    }

    
}
