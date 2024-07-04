//
//  UUID+Extension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

extension UUID {
    func toInt() -> Int {
        return self.hashValue
    }
}
