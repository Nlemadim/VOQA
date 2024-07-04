//
//  UserDefaultManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 1/18/24.
//

import Foundation

class UserDefaultsManager {
//    static func activateHandsfree(activate: Bool) {
//        UserDefaults.standard.set(activate, forKey: "isHandfreeEnabled")
//    }
    
    static func setQuizVoice(voice: String) {
        UserDefaults.standard.set(voice, forKey: "selectedVoice")
    }
    
    static func setQuizName(quizName: String) {
        UserDefaults.standard.set(quizName, forKey: "quizName")
    }
    
    
    static func setQuizMode(mode: String) {
        UserDefaults.standard.set(mode, forKey: "quizMode")
    }
    
    //TODO: Set at app launch
    static func setDefaultNumberOfTestQuestions(_ numberOfQuestions: Int) {
        UserDefaults.standard.set(numberOfQuestions, forKey: "numberOfTestQuestions")
    }
    
    static func updateNumberOfGlobalGlobalTopics() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfGlobalTopics")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfGlobalTopics")
    }
    
    static func setDefaultPointsPerQuestion() {
        let defaultPoints = 5
        if UserDefaults.standard.object(forKey: "pointsPerQuestion") == nil {
            UserDefaults.standard.set(defaultPoints, forKey: "pointsPerQuestion")
        }
    }
    
    static func updateResponseTime(_ responseTime: Int) {
        UserDefaults.standard.set(responseTime, forKey: "responseTimeKey")
    }
    
    static func setDefaultResponseTime() {
        UserDefaults.standard.set(6, forKey: "responseTimeKey")
    }
    
    static func incrementNumberOfTestsTaken() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfTestsTaken")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfTestsTaken")
    }
    
    static func incrementNumberOfQuizSessions() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfQuizSessions")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfQuizSessions")
    }
    
    static func incrementNumberOfCurrentQuizSessions() {
        let currentCount = UserDefaults.standard.integer(forKey: "currentQuizSessions")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfQuizSessions")
    }
    
    static func updateNumberOfGlobalQuestions() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfGlobalQuestions")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfGlobalQuestions")
    }
    
    static func updateNumberOfTopicsCovered() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfTopicsCovered")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfTopicsCovered")
    }
    
    static func incrementTotalQuestionsAnswered() {
        let currentCount = UserDefaults.standard.integer(forKey: "totalQuestionsAnswered")
        UserDefaults.standard.set(currentCount + 1, forKey: "totalQuestionsAnswered")
    }
    
    static func resetNumberOfQuestionsAnswered() {
        UserDefaults.standard.set(0, forKey: "totalQuestionsAnswered")
    }
    
    static func updateHighScore(_ score: Int) {
        let currentScore = UserDefaults.standard.integer(forKey: "userHighScore")
        if currentScore <= score {
            UserDefaults.standard.set(score, forKey: "userHighScore")
        }
    }
    
    static func enableContinousPlay(_ continousPlay: Bool) {
        UserDefaults.standard.setValue(continousPlay, forKey: "continousPlayEnabled")
    }
    
    static func enableHandsfree(_ micOn: Bool) {
        UserDefaults.standard.setValue(micOn, forKey: "isHandfreeEnabled")
    }
    
    static func hasFullVersion(_ hasFullVersion: Bool) {
        UserDefaults.standard.setValue(hasFullVersion, forKey: "hasFullVersion")
    }
    
    static func enableQandA(_ isQandA: Bool) {
        UserDefaults.standard.setValue(isQandA, forKey: "isQandAEnabled")
    }
    
    static func updateCurrentPosition(_ position: Int) {
        UserDefaults.standard.set(position, forKey: "quizCurrentPosition")
    }
    
    static func updateCurrentScoreStreak(correctAnswerCount: Int) {
        UserDefaults.standard.set(correctAnswerCount, forKey: "currentScoreStreak")
    }
    
    static func updateCurrentQuizStatus(inProgress: Bool) {
        UserDefaults.standard.set(inProgress, forKey: "quizInProgress")
    }
    
    static func updateHasDownloadedSample(_ isDownloaded: Bool, for quiz: String) {
        var samplesDictionary = UserDefaults.standard.dictionary(forKey: "sampleDownloads") as? [String: [String: Any]] ?? [String: [String: Any]]()
        
        samplesDictionary[quiz] = ["isDownloaded": isDownloaded]
        
        UserDefaults.standard.set(samplesDictionary, forKey: "sampleDownloads")
    }
    
    static func updateHasDownloadedFullVersion(_ isDownloaded: Bool, for quiz: String) {
        var samplesDictionary = UserDefaults.standard.dictionary(forKey: "hasFullVersion") as? [String: [String: Any]] ?? [String: [String: Any]]()
        
        samplesDictionary[quiz] = ["isDownloaded": isDownloaded]
        
        UserDefaults.standard.set(samplesDictionary, forKey: "hasFullVersion")
    }

    
    static func enableContinousFlow() {
        UserDefaults.standard.setValue(true, forKey: "isOnContinuousFlow")
    }
    
    static func updateRecievedInvalidResponseAdvisory() {
        UserDefaults.standard.setValue(true, forKey: "hasRecievedInvalidResponseAdvisory")
    }
    
    static func hasDownloadedSample(for quiz: String) -> Bool? {
        guard let samplesDictionary = UserDefaults.standard.dictionary(forKey: "sampleDownloads") as? [String: [String: Any]],
              let quizData = samplesDictionary[quiz],
              let isDownloaded = quizData["isDownloaded"] as? Bool else {
            return nil
        }
        return isDownloaded
    }
    
    static func hasFullVersion(for quiz: String) -> Bool? {
        guard let samplesDictionary = UserDefaults.standard.dictionary(forKey: "hasFullVersion") as? [String: [String: Any]],
              let quizData = samplesDictionary[quiz],
              let isDownloaded = quizData["isDownloaded"] as? Bool else {
            return nil
        }
        return isDownloaded
    }

    
    static func userName() -> String {
        return UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    
    static func selectedVoice() -> String {
        return UserDefaults.standard.string(forKey: "selectedVoice") ?? ""
    }
    
    static func quizMode() -> String {
        return UserDefaults.standard.string(forKey: "quizMode") ?? ""
    }
    
    static func isStudyModeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isStudyMode")
        
    }
    
    static func hasDownloadedSample() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasDownloadedSample")

    }
    
    static func isHandfreeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isHandfreeEnabled")
    }
    
    static func isQandAEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isQandAEnabled")
    }
    
    static func hasRecievedInvalidResponseAdvisory() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasRecievedInvalidResponseAdvisory")
    }
    
    static func isContinousPlayEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "continousPlayEnabled")
    }
    
    static func isTimerEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isTimerEnabled")
    }
    
    static func isFocusEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isFocusEnabled")
    }
    
    static func userHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: "userHighScore")
    }
    
    static func currentPlayPosition() -> Int {
        return UserDefaults.standard.integer(forKey: "quizCurrentPosition")
    }
    
    static func currentScoreStreak() -> Int {
        return UserDefaults.standard.integer(forKey: "currentScoreStreak")
    }
    
    static func quizInProgress() -> Bool {
        return UserDefaults.standard.bool(forKey: "quizInProgress")
    }
    
    static func globalTopics() -> String {
        return UserDefaults.standard.string(forKey: "globalTopics") ?? ""
    }
    
    static func numberOfGlobalTopics() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfGlobalTopics")
    }
    
    static func numberOfTopicsCovered() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTopicsCovered")
    }
    
    static func topicsInFocus() -> String {
        return UserDefaults.standard.string(forKey: "topicsInFocus") ?? ""
    }
    
    static func numberOfTestsTaken() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTestsTaken")
    }
    
    static func numberOfQuizSessions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfQuizSessions")
    }
    
    static func currentQuizSessions() -> Int {
        return UserDefaults.standard.integer(forKey: "currentQuizSessions")
    }
    
    static func totalQuestionsAnswered() -> Int {
        return UserDefaults.standard.integer(forKey: "totalQuestionsAnswered")
    }
    
    static func numberOfGlobalQuestions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfGlobalQuestions")
    }
    
    static func numberOfTestQuestions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTestQuestions")
    }
    
    static func quizName() -> String {
        return UserDefaults.standard.string(forKey: "userDownloadedAudioQuizName") ?? "Unknown Quiz"
    }
    
    static func pointsPerQuestion() -> Int {
        return UserDefaults.standard.integer(forKey: "pointsPerQuestion")
        
    }
    
    static func responseTime() -> Int {
        return UserDefaults.standard.integer(forKey: "responseTimeKey")
    }
    
    static func resetAllValues() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            print("All data has been Reset!")
        }
    }
    
}

