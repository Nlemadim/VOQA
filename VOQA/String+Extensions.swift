//
//  String+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import Foundation

extension String {
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isSingleCharacterABCD: Bool {
        return self.count == 1 && ["A", "B", "C", "D"].contains(self.uppercased())
    }
    
    // Calculate similarity ratio using a simplified method for demonstration
    func similarityRatio(to compare: String) -> Double {
        let thisSet = Set(self)
        let compareSet = Set(compare)
        let intersection = thisSet.intersection(compareSet).count
        let union = thisSet.union(compareSet).count
        return union == 0 ? 0 : Double(intersection) / Double(union)
    }
}


