//
//  String+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import Foundation

extension String {
    func removingLeadingNumber() -> String {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let index = trimmedText.firstIndex(where: { !$0.isNumber && $0 != "." }) else {
            return self // Return original if no non-numeric character found
        }
        return String(trimmedText[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parserFilter() -> String {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // Combine the check for numbers, periods, and ensure it's not a special character to be removed.
        guard let index = trimmedText.firstIndex(where: { !$0.isNumber && $0 != "." && !$0.isPunctuation }) else {
            return self // Return original if no valid starting point is found.
        }
        return String(trimmedText[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isSingleCharacterABCD: Bool {
        return self.count == 1 && ["A", "B", "C", "D"].contains(self.uppercased())
    }
}
