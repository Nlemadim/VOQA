//
//  HapticFeedback.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/26/24.
//

import Foundation
import SwiftUI

struct HapticFeedback {
    static func selectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
