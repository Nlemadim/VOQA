//
//  QuestionRequestBody.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

struct QuestionRequestBody: Codable {
    var userId: String
    var quizTitle: String
    var prompt: String?
    var narratorId: String
    var numberOfQuestions: Int
}

/**
 
 [VOQA.Question(refId: "ca007f3b-424c-45e8-8305-0408d576da03", content: "In the context of cellular respiration, what role does the electron transport chain play?", mcOptions: ["C: Generates ATP by oxidative phosphorylation": true, "A: Breaks down glucose into pyruvate": false, "D: Facilitates the synthesis of protein": false, "B: Synthesizes glucose through photosynthesis": false], correctOption: nil, selectedOption: nil, correction: "Your engagement with this question is appreciated, yet the precise answer is Option C: Generates ATP by oxidative phosphorylation. The electron transport chain is integral to cellular respiration, transferring electrons from NADH and FADH2 to oxygen, a process known as oxidative phosphorylation. This critical step generates a significant amount of ATP, the energy currency of the cell, supporting various cellular functions. This understanding underscores the importance of energy production mechanisms in biology.", isAnsweredOptional: nil, isAnsweredCorrectlyOptional: nil, numberOfPresentations: 2, questionScript: "Let\'s dive into the fascinating world of cellular respiration, a crucial process that cells use to break down glucose and produce the energy carrier, ATP. A key player in this process is the electron transport chain, known for its role in oxidative phosphorylation. *Here are your options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein. Reflect on each option and choose wisely.", repeatQuestionScript: "In the context of cellular respiration, what role does the electron transport chain play? *Here are the options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein.", questionScriptAudioUrl: Optional("https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_questionScript.mp3"), correctionAudioUrl: Optional("https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_correction.mp3"), repeatQuestionAudioUrl: Optional("https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_repeatQuestionScript.mp3"), coreTopic: "Biological and Biochemical Foundations", quizId: "MCAT", userId: "rBkUyTtc2XXXcj43u53N", questionStatus: Optional(VOQA.QuestionStatus(isAnsweredCorrectly: Optional(false), isAnswered: Optional(false), knowledgeConfirmed: Optional(false))))]
 
 
 Quiz Player viewModel has initialized a session
 QuizSessionManager initialized
 current question ID: nil
 Context Player Hit
 QuizPlayer has: 0 questions
 Ready to play 0 questions
 QuestionPlayer performAction called with action: setSessionQuestions([])
 Current Question Index: 0
 Total Questions: 0
 Questions Unavailable
 Starting countdown
 UserConfig loaded successfully for userId: 4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58
 
 
 */
