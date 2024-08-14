//
//  Collection+Extension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/7/24.
//

import Foundation
import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
