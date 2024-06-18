//
//  Item.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
