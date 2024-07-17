//
//  VoiceFeedbackMessages.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation
import SwiftData

@Model
class VoiceFeedbackMessages {
    var id: UUID
    var quizStartScript: String
    var quizEndingScript: String
    var nextQuestionCalloutScript: String
    var finalQuestionCalloutScript: String
    var repeatQuestionCalloutScript: String
    var listeningCalloutScript: String
    var waitingForResponseCalloutScript: String
    var pausedCalloutScript: String
    var correctAnswerCalloutScript: String
    var correctAnswerLowStreakCallOutScript: String
    var correctAnswerMidStreakCalloutScript: String
    var correctAnswerHighStreakCalloutScript: String
    var inCorrectAnswerCalloutScript: String
    var zeroScoreCommentScript: String
    var tenPercentScoreCommentScript: String
    var twentyPercentScoreCommentScript: String
    var thirtyPercentScoreCommentScript: String
    var fortyPercentScoreCommentScript: String
    var fiftyPercentScoreCommentScript: String
    var sixtyPercentScoreCommentScript: String
    var seventyPercentScoreCommentScript: String
    var eightyPercentScoreCommentScript: String
    var ninetyPercentScoreCommentScript: String
    var perfectScoreCommentScript: String
    var errorTranscriptionScript: String
    var invalidResponseCalloutScript: String
    var invalidResponseUserAdvisoryScript: String
    
    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var nextQuestionCalloutAudioUrl: String
    var finalQuestionCalloutAudioUrl: String
    var repeatQuestionCalloutAudioUrl: String
    var listeningCalloutAudioUrl: String
    var waitingForResponseCalloutAudioUrl: String
    var pausedCalloutAudioUrl: String
    var correctAnswerCalloutAudioUrl: String
    var correctAnswerLowStreakCallOutAudioUrl: String
    var correctAnswerMidStreakCalloutAudioUrl: String
    var correctAnswerHighStreakCalloutAudioUrl: String
    var inCorrectAnswerCalloutAudioUrl: String
    var zeroScoreCommentAudioUrl: String
    var tenPercentScoreCommentAudioUrl: String
    var twentyPercentScoreCommentAudioUrl: String
    var thirtyPercentScoreCommentAudioUrl: String
    var fortyPercentScoreCommentAudioUrl: String
    var fiftyPercentScoreCommentAudioUrl: String
    var sixtyPercentScoreCommentAudioUrl: String
    var seventyPercentScoreCommentAudioUrl: String
    var eightyPercentScoreCommentAudioUrl: String
    var ninetyPercentScoreCommentAudioUrl: String
    var perfectScoreCommentAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var invalidResponseCalloutAudioUrl: String
    var invalidResponseUserAdvisoryAudioUrl: String
    
    init(
        id: UUID = UUID(),
        quizStartScript: String = "",
        quizEndingScript: String = "",
        nextQuestionCalloutScript: String = "",
        finalQuestionCalloutScript: String = "",
        repeatQuestionCalloutScript: String = "",
        listeningCalloutScript: String = "",
        waitingForResponseCalloutScript: String = "",
        pausedCalloutScript: String = "",
        correctAnswerCalloutScript: String = "",
        correctAnswerLowStreakCallOutScript: String = "",
        correctAnswerMidStreakCalloutScript: String = "",
        correctAnswerHighStreakCalloutScript: String = "",
        inCorrectAnswerCalloutScript: String = "",
        zeroScoreCommentScript: String = "",
        tenPercentScoreCommentScript: String = "",
        twentyPercentScoreCommentScript: String = "",
        thirtyPercentScoreCommentScript: String = "",
        fortyPercentScoreCommentScript: String = "",
        fiftyPercentScoreCommentScript: String = "",
        sixtyPercentScoreCommentScript: String = "",
        seventyPercentScoreCommentScript: String = "",
        eightyPercentScoreCommentScript: String = "",
        ninetyPercentScoreCommentScript: String = "",
        perfectScoreCommentScript: String = "",
        errorTranscriptionScript: String = "",
        invalidResponseCalloutScript: String = "",
        invalidResponseUserAdvisoryScript: String = "",
        quizStartAudioUrl: String = "",
        quizEndingAudioUrl: String = "",
        nextQuestionCalloutAudioUrl: String = "",
        finalQuestionCalloutAudioUrl: String = "",
        repeatQuestionCalloutAudioUrl: String = "",
        listeningCalloutAudioUrl: String = "",
        waitingForResponseCalloutAudioUrl: String = "",
        pausedCalloutAudioUrl: String = "",
        correctAnswerCalloutAudioUrl: String = "",
        correctAnswerLowStreakCallOutAudioUrl: String = "",
        correctAnswerMidStreakCalloutAudioUrl: String = "",
        correctAnswerHighStreakCalloutAudioUrl: String = "",
        inCorrectAnswerCalloutAudioUrl: String = "",
        zeroScoreCommentAudioUrl: String = "",
        tenPercentScoreCommentAudioUrl: String = "",
        twentyPercentScoreCommentAudioUrl: String = "",
        thirtyPercentScoreCommentAudioUrl: String = "",
        fortyPercentScoreCommentAudioUrl: String = "",
        fiftyPercentScoreCommentAudioUrl: String = "",
        sixtyPercentScoreCommentAudioUrl: String = "",
        seventyPercentScoreCommentAudioUrl: String = "",
        eightyPercentScoreCommentAudioUrl: String = "",
        ninetyPercentScoreCommentAudioUrl: String = "",
        perfectScoreCommentAudioUrl: String = "",
        errorTranscriptionAudioUrl: String = "",
        invalidResponseCalloutAudioUrl: String = "",
        invalidResponseUserAdvisoryAudioUrl: String = ""
    ) {
        self.id = id
        self.quizStartScript = quizStartScript
        self.quizEndingScript = quizEndingScript
        self.nextQuestionCalloutScript = nextQuestionCalloutScript
        self.finalQuestionCalloutScript = finalQuestionCalloutScript
        self.repeatQuestionCalloutScript = repeatQuestionCalloutScript
        self.listeningCalloutScript = listeningCalloutScript
        self.waitingForResponseCalloutScript = waitingForResponseCalloutScript
        self.pausedCalloutScript = pausedCalloutScript
        self.correctAnswerCalloutScript = correctAnswerCalloutScript
        self.correctAnswerLowStreakCallOutScript = correctAnswerLowStreakCallOutScript
        self.correctAnswerMidStreakCalloutScript = correctAnswerMidStreakCalloutScript
        self.correctAnswerHighStreakCalloutScript = correctAnswerHighStreakCalloutScript
        self.inCorrectAnswerCalloutScript = inCorrectAnswerCalloutScript
        self.zeroScoreCommentScript = zeroScoreCommentScript
        self.tenPercentScoreCommentScript = tenPercentScoreCommentScript
        self.twentyPercentScoreCommentScript = twentyPercentScoreCommentScript
        self.thirtyPercentScoreCommentScript = thirtyPercentScoreCommentScript
        self.fortyPercentScoreCommentScript = fortyPercentScoreCommentScript
        self.fiftyPercentScoreCommentScript = fiftyPercentScoreCommentScript
        self.sixtyPercentScoreCommentScript = sixtyPercentScoreCommentScript
        self.seventyPercentScoreCommentScript = seventyPercentScoreCommentScript
        self.eightyPercentScoreCommentScript = eightyPercentScoreCommentScript
        self.ninetyPercentScoreCommentScript = ninetyPercentScoreCommentScript
        self.perfectScoreCommentScript = perfectScoreCommentScript
        self.errorTranscriptionScript = errorTranscriptionScript
        self.invalidResponseCalloutScript = invalidResponseCalloutScript
        self.invalidResponseUserAdvisoryScript = invalidResponseUserAdvisoryScript
        self.quizStartAudioUrl = quizStartAudioUrl
        self.quizEndingAudioUrl = quizEndingAudioUrl
        self.nextQuestionCalloutAudioUrl = nextQuestionCalloutAudioUrl
        self.finalQuestionCalloutAudioUrl = finalQuestionCalloutAudioUrl
        self.repeatQuestionCalloutAudioUrl = repeatQuestionCalloutAudioUrl
        self.listeningCalloutAudioUrl = listeningCalloutAudioUrl
        self.waitingForResponseCalloutAudioUrl = waitingForResponseCalloutAudioUrl
        self.pausedCalloutAudioUrl = pausedCalloutAudioUrl
        self.correctAnswerCalloutAudioUrl = correctAnswerCalloutAudioUrl
        self.correctAnswerLowStreakCallOutAudioUrl = correctAnswerLowStreakCallOutAudioUrl
        self.correctAnswerMidStreakCalloutAudioUrl = correctAnswerMidStreakCalloutAudioUrl
        self.correctAnswerHighStreakCalloutAudioUrl = correctAnswerHighStreakCalloutAudioUrl
        self.inCorrectAnswerCalloutAudioUrl = inCorrectAnswerCalloutAudioUrl
        self.zeroScoreCommentAudioUrl = zeroScoreCommentAudioUrl
        self.tenPercentScoreCommentAudioUrl = tenPercentScoreCommentAudioUrl
        self.twentyPercentScoreCommentAudioUrl = twentyPercentScoreCommentAudioUrl
        self.thirtyPercentScoreCommentAudioUrl = thirtyPercentScoreCommentAudioUrl
        self.fortyPercentScoreCommentAudioUrl = fortyPercentScoreCommentAudioUrl
        self.fiftyPercentScoreCommentAudioUrl = fiftyPercentScoreCommentAudioUrl
        self.sixtyPercentScoreCommentAudioUrl = sixtyPercentScoreCommentAudioUrl
        self.seventyPercentScoreCommentAudioUrl = seventyPercentScoreCommentAudioUrl
        self.eightyPercentScoreCommentAudioUrl = eightyPercentScoreCommentAudioUrl
        self.ninetyPercentScoreCommentAudioUrl = ninetyPercentScoreCommentAudioUrl
        self.perfectScoreCommentAudioUrl = perfectScoreCommentAudioUrl
        self.errorTranscriptionAudioUrl = errorTranscriptionAudioUrl
        self.invalidResponseCalloutAudioUrl = invalidResponseCalloutAudioUrl
        self.invalidResponseUserAdvisoryAudioUrl = invalidResponseUserAdvisoryAudioUrl
    }
}

struct VoiceFeedbackContainer {
    var id: UUID
    var quizStartMessageScript: String
    var quizEndingMessageScript: String
    var nextQuestionCalloutScript: String
    var finalQuestionCalloutScript: String
    var repeatQuestionCalloutScript: String
    var listeningCalloutScript: String
    var waitingForResponseCalloutScript: String
    var pausedCalloutScript: String
    var correctAnswerCalloutScript: String
    var correctAnswerLowStreakCallOutScript: String
    var correctAnswerMidStreakCalloutScript: String
    var correctAnswerHighStreakCalloutScript: String
    var inCorrectAnswerCalloutScript: String
    var zeroScoreCommentScript: String
    var tenPercentScoreCommentScript: String
    var twentyPercentScoreCommentScript: String
    var thirtyPercentScoreCommentScript: String
    var fortyPercentScoreCommentScript: String
    var fiftyPercentScoreCommentScript: String
    var sixtyPercentScoreCommentScript: String
    var seventyPercentScoreCommentScript: String
    var eightyPercentScoreCommentScript: String
    var ninetyPercentScoreCommentScript: String
    var perfectScoreCommentScript: String
    var errorTranscriptionScript: String
    var invalidResponseCalloutScript: String
    var invalidResponseUserAdvisoryScript: String
    
    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var nextQuestionCalloutAudioUrl: String
    var finalQuestionCalloutAudioUrl: String
    var repeatQuestionCalloutAudioUrl: String
    var listeningCalloutAudioUrl: String
    var waitingForResponseCalloutAudioUrl: String
    var pausedCalloutAudioUrl: String
    var correctAnswerCalloutAudioUrl: String
    var correctAnswerLowStreakCallOutAudioUrl: String
    var correctAnswerMidStreakCalloutAudioUrl: String
    var correctAnswerHighStreakCalloutAudioUrl: String
    var inCorrectAnswerCalloutAudioUrl: String
    var zeroScoreCommentAudioUrl: String
    var tenPercentScoreCommentAudioUrl: String
    var twentyPercentScoreCommentAudioUrl: String
    var thirtyPercentScoreCommentAudioUrl: String
    var fortyPercentScoreCommentAudioUrl: String
    var fiftyPercentScoreCommentAudioUrl: String
    var sixtyPercentScoreCommentAudioUrl: String
    var seventyPercentScoreCommentAudioUrl: String
    var eightyPercentScoreCommentAudioUrl: String
    var ninetyPercentScoreCommentAudioUrl: String
    var perfectScoreCommentAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var invalidResponseCalloutAudioUrl: String
    var invalidResponseUserAdvisoryAudioUrl: String
}
