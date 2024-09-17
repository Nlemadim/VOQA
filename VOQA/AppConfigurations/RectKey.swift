//
//  RectKey.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//

import Foundation
import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
