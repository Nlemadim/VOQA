//
//  WordProcessor.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation


enum WordProcessor: String {
    case A, B, C, D

    static func processWords(from transcript: String) -> String {
        let lowercasedTranscript = transcript.lowercased()

        switch lowercasedTranscript {
        case "a", "eh", "ay", "hey", "ea", "hay", "aye", "option A", "option eh", "option ay", "option hey", "option aye":
            return WordProcessor.A.rawValue
            
        case "b", "be", "bee", "beat", "bei", "bead", "bay", "bye", "buh", "option B", "option be", "option bee", "option bei", "option bay":
            return WordProcessor.B.rawValue
            
        case "c", "see", "sea", "si", "cee", "seed", "option C", "option see", "option si", "option seed":
            return WordProcessor.C.rawValue
            
        case "d", "dee", "the", "di", "dey", "they", "option D", "option dee", "option the", "option dey":
            return WordProcessor.D.rawValue
            
        default:
            return "Error" // To be modified with a word comparison algo and network response validation api
        }
    }
}

enum WordProcessorV2: String {
    case A, B, C, D, Invalid
    
    static func processWords(from transcript: String, comparedWords: [String] = []) -> String {
        let lowercasedTranscript = transcript.lowercased()
        
        // Check for predefined simple matches first
        switch lowercasedTranscript {
        case "a", "eh", "ay", "hey", "ea", "hay", "aye", "option A", "option eh", "option ay", "option hey", "option aye":
            return WordProcessorV2.A.rawValue
            
        case "b", "be", "bee", "beat", "bei", "bead", "bay", "bye", "buh", "option B", "option be", "option bee", "option bei", "option bay":
            return WordProcessorV2.B.rawValue
            
        case "c", "see", "sea", "si", "cee", "seed", "option C", "option see", "option si", "option seed":
            return WordProcessorV2.C.rawValue
            
        case "d", "dee", "the", "di", "dey", "they", "option D", "option dee", "option the", "option dey":
            return WordProcessorV2.D.rawValue
            
        default:
            // If no predefined matches, check dynamically provided words
            let dynamicResult = processDynamicWords(transcript: lowercasedTranscript, comparedWords: comparedWords)
            return dynamicResult == WordProcessorV2.Invalid.rawValue ? "Invalid Response" : dynamicResult
        }
    }
    
    
    static private func processDynamicWords(transcript: String, comparedWords: [String]) -> String {
        let normalizedTranscript = transcript.lowercased()
        for (index, word) in comparedWords.enumerated() {
            let normalizedWord = word.lowercased()
            if normalizedTranscript == normalizedWord {
                // Return the corresponding letter for the matched index
                if let letter = UnicodeScalar("A".unicodeScalars.first!.value + UInt32(index)) {
                    return String(letter)
                }
            }
        }
        
        return WordProcessorV2.Invalid.rawValue // Return "Invalid" if no matches are found
    }
}
