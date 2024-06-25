//
//  AudioContentPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import Foundation
import AVFoundation
import Combine
import Speech

class AudioContentPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, StateObserver {
    @Published var isPlaying: Bool = false
    @Published var currentPlaybackPower: Float = 0.0
    @Published var currentQuestionIndex: Int = 0
    @Published var currentQuestionContent: String = ""
    @Published var hasNextQuestion: Bool = false
    @Published var appError: (any AppError)? // Use 'any AppError'

    var questions: [Question] = []
    var context: QuizContext

    // Internal properties accessible to extensions and other classes within the module
    internal var audioPlayer: AVAudioPlayer?
    internal var secondaryPlayer: AVAudioPlayer?
    internal var feedbackPlayer: AVAudioPlayer?
    internal var volume: Float = 1.0
    internal var shouldPlay: Bool = true

    init(context: QuizContext) {
        self.context = context
        super.init()
        configureAudioSession()
        loadCurrentQuestionIndex()
        context.state.addObserver(self)
        context.audioPlayer = self // Set the audioPlayer reference in context
        
    }

    func stateDidChange(to newState: any QuizState) {
        // Handle state changes as necessary
    }

    func pausePlayback() {
        audioPlayer?.pause()
        secondaryPlayer?.pause()
    }

    func stopAndResetPlayer() {
        shouldPlay = false
        audioPlayer?.stop()
        secondaryPlayer?.stop()
        audioPlayer = nil
        secondaryPlayer = nil
    }
}







//import Foundation
//import AVFoundation
//import Combine
//import Speech

//class AudioContentPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, StateObserver {
//    @Published var isPlaying: Bool = false
//    @Published var currentPlaybackPower: Float = 0.0
//    @Published var currentQuestionIndex: Int = 0
//    @Published var currentQuestionContent: String = ""
//    @Published var hasNextQuestion: Bool = false
//    @Published var appError: (any AppError)? // Use 'any AppError'
//
//    private var audioPlayer: AVAudioPlayer?
//    private var secondaryPlayer: AVAudioPlayer?
//    private var feedbackPlayer: AVAudioPlayer?
//    private var volume: Float = 1.0
//    var questions: [Question] = []
//    private var shouldPlay: Bool = true
//    var context: QuizContext
//
//    init(context: QuizContext) {
//        self.context = context
//        super.init()
//        configureAudioSession()
//        loadCurrentQuestionIndex()
//        context.state.addObserver(self)
//        context.audioPlayer = self // Set the audioPlayer reference in context
//        updateHasNextQuestion()
//    }
//
//    private func configureAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to set audio session category: \(error)")
//        }
//    }
//
//    func stateDidChange(to newState: any QuizState) {
//        // Handle state changes as necessary
//    }
//
//    func pausePlayback() {
//        audioPlayer?.pause()
//        secondaryPlayer?.pause()
//    }
//
//    func stopAndResetPlayer() {
//        print("Player stopped")
//        shouldPlay = false
//        audioPlayer?.stop()
//        secondaryPlayer?.stop()
//        audioPlayer = nil
//        secondaryPlayer = nil
//    }
//
//    func playQuestions(_ questions: [Question]) {
//        self.questions = questions
//        context.activeQuiz = true
//        playCurrentQuestion()
//    }
//
//    func updateHasNextQuestion() {
//        hasNextQuestion = currentQuestionIndex + 1 < questions.count
//    }
//    
//    func updateCurrentQuestionContent() {
//        guard self.context.activeQuiz else { return }
//        //currentQuestionContent = questions[currentQuestionIndex].content
//    }
//
//
//    func playCurrentQuestion() {
//        guard currentQuestionIndex < questions.count else {
//            print("No more questions to play.")
//            context.setState(ReviewState(action: .reviewing))
//            return
//        }
//
//        let question = questions[currentQuestionIndex]
//        currentQuestionContent = question.content
//
//        do {
//            try startPlaybackFromBundle(fileName: question.audioUrl.deletingPathExtension, fileType: question.audioUrl.pathExtension)
//        } catch {
//            print("Could not load file: \(error.localizedDescription)")
//            handleError(.fileNotFound, message: "The audio file for the question could not be found.")
//        }
//
//        updateHasNextQuestion()
//    }
//
//
//    func skipToQuestion(withId id: UUID) {
//        guard let index = questions.firstIndex(where: { $0.id == id }), index + 1 < questions.count else { return }
//        currentQuestionIndex = index + 1
//        playCurrentQuestion()
//    }
//
//    func stateManagedSkipToNextQuestion() {
//        guard currentQuestionIndex + 1 < questions.count else { return }
//        currentQuestionIndex += 1
//        playCurrentQuestion()
//    }
//    
//    func playFeedbackAudio(type: FeedbackMessageState.FeedbackType, audioFile: String) {
//        do {
//            try startPlaybackFromBundle(fileName: audioFile.deletingPathExtension, fileType: audioFile.pathExtension, isFeedback: true)
//        } catch {
//            print("Could not load file: \(error.localizedDescription)")
//            handleError(.fileNotFound, message: "The feedback audio file could not be found.")
//        }
//    }
//
//
//    func playReviewAudio(_ audioFiles: [String]) {
//        playMultipleAudioFiles(audioFiles, currentIndex: 0)
//    }
//
//    func playMultiAudioFiles(mainFile: String, bgmFile: String) {
//        shouldPlay = true
//        do {
//            try startPlaybackFromBundle(fileName: mainFile.deletingPathExtension, fileType: mainFile.pathExtension)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                if self.shouldPlay {
//                    do {
//                        try self.startPlaybackFromBundle(fileName: bgmFile.deletingPathExtension, fileType: bgmFile.pathExtension, isBackground: true)
//                    } catch {
//                        print("Could not load background music file: \(error.localizedDescription)")
//                        self.handleError(.fileNotFound, message: "The background music file could not be found.")
//                    }
//                }
//            }
//        } catch {
//            print("Could not load main file: \(error.localizedDescription)")
//            handleError(.fileNotFound, message: "The main audio file could not be found.")
//        }
//    }
//
//    func playBackgroundMusic(_ bgmFile: String, mainFile: String) {
//        do {
//            try startPlaybackFromBundle(fileName: bgmFile.deletingPathExtension, fileType: bgmFile.pathExtension, isBackground: true)
//            try startPlaybackFromBundle(fileName: mainFile.deletingPathExtension, fileType: mainFile.pathExtension)
//        } catch {
//            print("Could not load file: \(error.localizedDescription)")
//            handleError(.fileNotFound, message: "The background or main audio file could not be found.")
//        }
//    }
//
//    func setVolume(_ volume: Float) {
//        self.volume = volume
//        audioPlayer?.volume = volume
//        secondaryPlayer?.volume = volume / 2
//        feedbackPlayer?.volume = volume
//    }
//
//    func getAudioDuration(for audioFile: String) -> TimeInterval? {
//        do {
//            let player = try AVAudioPlayer(contentsOf: getDocumentDirectoryURL(for: audioFile) ?? URL(fileURLWithPath: ""))
//            return player.duration
//        } catch {
//            print("Could not load file: \(error.localizedDescription)")
//            handleError(.fileNotFound, message: "The audio file duration could not be retrieved.")
//            return nil
//        }
//    }
//
//    private func playMultipleAudioFiles(_ audioFiles: [String], currentIndex: Int, secondaryVolume: Float = 1.0) {
//        guard currentIndex < audioFiles.count else {
//            return
//        }
//
//        let audioFile = audioFiles[currentIndex]
//
//        do {
//            try startPlaybackFromBundle(fileName: audioFile.deletingPathExtension, fileType: audioFile.pathExtension, secondaryVolume: secondaryVolume)
//            DispatchQueue.main.asyncAfter(deadline: .now() + audioPlayer!.duration) {
//                self.playMultipleAudioFiles(audioFiles, currentIndex: currentIndex + 1, secondaryVolume: secondaryVolume)
//                print(self.currentPlaybackPower)
//            }
//        } catch {
//            print("Could not load file: \(error.localizedDescription)")
//        }
//    }
//
//    private func startPlaybackFromBundle(fileName: String, fileType: String = "mp3", isFeedback: Bool = false, isBackground: Bool = false, secondaryVolume: Float = 0.3) throws {
//        let audioSession = AVAudioSession.sharedInstance()
//        if audioSession.category != .playback {
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//        }
//
//        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//            let url = URL(fileURLWithPath: path)
//            
//            let player = try AVAudioPlayer(contentsOf: url)
//            player.delegate = self
//            player.volume = isBackground ? volume / 2 : volume
//            player.prepareToPlay()
//            player.play()
//
//            if isFeedback {
//                feedbackPlayer = player
//            } else if isBackground {
//                secondaryPlayer = player
//                secondaryPlayer?.volume = secondaryVolume
//            } else {
//                audioPlayer = player
//            }
//
//            isPlaying = true
//        } else {
//            throw AudioPlayerError(title: "File Not Found", message: "The audio file \(fileName) could not be found.", errorType: .fileNotFound)
//        }
//    }
//
//    private func getDocumentDirectoryURL(for fileName: String) -> URL? {
//        let fileManager = FileManager.default
//        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return nil
//        }
//        return documentsDirectory.appendingPathComponent(fileName)
//    }
//
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        DispatchQueue.main.async {
//            self.isPlaying = false
//            print("Audio player finished playing")
//            if player == self.audioPlayer {
//                print("Main audio player finished")
//                self.secondaryPlayer?.stop()
//                if self.context.activeQuiz {
//                
//                    self.context.setState(ListeningState())
//                }
//            } else if player == self.secondaryPlayer {
//                print("Secondary audio player finished")
//                // Handle completion of secondary player if needed
//            } else if player == self.feedbackPlayer {
//                print("Feedback player finished")
//                if self.context.activeQuiz {
//                    self.context.setState(PlaybackState(action: .resume))
//                }
//            } else if player == self.audioPlayer && !self.context.activeQuiz {
//                self.context.setState(ReviewState(action: .doneReviewing))
//            } else {
//                print("Unknown player finished")
//            }
//        }
//    }
//
//
//
//    func updateMeters() {
//        audioPlayer?.updateMeters()
//        if let power = audioPlayer?.averagePower(forChannel: 0) {
//            DispatchQueue.main.async {
//                self.currentPlaybackPower = power
//            }
//        }
//    }
//
//    func playWithSiri(_ script: String) {
//        let speechSynthesizer = AVSpeechSynthesizer()
//        let speechUtterance = AVSpeechUtterance(string: script)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//
//        speechSynthesizer.speak(speechUtterance)
//
//        // context.setState(ListeningState())
//    }
//
//    private func saveCurrentQuestionIndex() {
//        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
//    }
//
//    private func loadCurrentQuestionIndex() {
//        currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
//        updateHasNextQuestion()
//        updateCurrentQuestionContent()
//    }
//
//    private func handleError(_ errorType: AudioPlayerErrorType, message: String) {
//        let error = AudioPlayerError(title: "Playback Error", message: message, errorType: errorType)
//        DispatchQueue.main.async {
//            self.appError = error
//        }
//    }
//}
//
//
//
//
//
//
