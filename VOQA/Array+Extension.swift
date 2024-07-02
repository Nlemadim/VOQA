//
//  Array+Extension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/29/24.
//

import Foundation
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
