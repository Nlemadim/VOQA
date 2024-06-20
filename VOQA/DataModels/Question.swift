//
//  Question.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Question: ObservableObject {
    @Attribute(.unique) var id: UUID
    var topicId: UUID
    var content: String
    var options: [String]
    var correctOption: String
    var selectedOption: String = ""
    var isAnswered: Bool = false
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var ratings: Int
    var numberOfRatings: Int
    var audioScript: String
    var audioUrl: String
    var replayQuestionAudioScript: String
    var replayOptionAudioScript: String
    var status: QuestionStatus
    
    init(id: UUID, topicId: UUID, content: String, options: [String], correctOption: String, selectedOption: String = "", isAnswered: Bool = false, isAnsweredCorrectly: Bool, numberOfPresentations: Int = 0, ratings: Int = 0, numberOfRatings: Int = 0, audioScript: String, audioUrl: String, replayQuestionAudioScript: String, replayOptionAudioScript: String, status: QuestionStatus) {
        self.id = id
        self.topicId = topicId
        self.content = content
        self.options = options
        self.correctOption = correctOption
        self.selectedOption = selectedOption
        self.isAnswered = isAnswered
        self.isAnsweredCorrectly = isAnsweredCorrectly
        self.numberOfPresentations = numberOfPresentations
        self.ratings = ratings
        self.numberOfRatings = numberOfRatings
        self.audioScript = audioScript
        self.audioUrl = audioUrl
        self.replayQuestionAudioScript = replayQuestionAudioScript
        self.replayOptionAudioScript = replayOptionAudioScript
        self.status = status
    }
    
    convenience init(id: UUID = UUID()) {
        self.init(id: id, topicId: UUID(), content: "", options: [], correctOption: "", isAnsweredCorrectly: false, audioScript: "", audioUrl: "", replayQuestionAudioScript: "", replayOptionAudioScript: "", status: .newQuestion)
    }
    
    convenience init(id: UUID = UUID(), topicId: UUID, content: String, options: [String], correctOption: String, audioScript: String, audioUrl: String, replayQuestionAudioScript: String, replayOptionAudioScript: String) {
        self.init(id: id, topicId: topicId, content: content, options: options, correctOption: correctOption, isAnsweredCorrectly: false, audioScript: audioScript, audioUrl: audioUrl, replayQuestionAudioScript: replayQuestionAudioScript, replayOptionAudioScript: replayOptionAudioScript, status: .newQuestion)
    }
}
