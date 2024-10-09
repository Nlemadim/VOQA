//
//  QuestionType-Protocol.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/4/24.
//

import Foundation
/// A protocol that defines the essential properties required by QuestionPlayer to handle any question type.
protocol QuestionType: Codable, Identifiable where ID == String {
    /// A unique identifier for the question.
    var id: String { get }

    /// The main content or text of the question.
    var content: String { get }

    /// A dictionary representing the options for the question.
    var mcOptions: [String: Bool] { get }

    /// The option selected by the user.
    var selectedOption: String? { get }

    /// The correction or explanation for the question.
    var correction: String { get }

    /// The number of times the question has been presented.
    var numberOfPresentations: Int { get }

    /// The script for the question's audio narration.
    var questionScript: String { get }

    /// The script for repeating the question's audio narration.
    var repeatQuestionScript: String { get }

    /// The URL string pointing to the question script audio.
    var questionScriptAudioURL: String? { get }

    /// The URL string pointing to the correction audio.
    var correctionAudioURL: String? { get }

    /// The URL string pointing to the repeat question audio.
    var repeatQuestionAudioURL: String? { get }

    /// The core topic of the question.
    var coreTopic: String { get }

    /// The identifier for the associated quiz.
    var quizId: String { get }

    /// The identifier for the user who answered the question.
    var userId: String { get }

    /// The status of the question.
    var questionStatus: QuestionStatus? { get }
}


extension QuestionType where Self == Question {
    /// Selects an option and checks if it's correct.
    /// - Parameter selectedOption: The option selected by the user.
    /// - Returns: `true` if the selected option is correct, `false` otherwise.
    mutating func selectOption(selectedOption: String) -> Bool {
        self.selectedOption = selectedOption
        return self.mcOptions[selectedOption] ?? false
    }
}
