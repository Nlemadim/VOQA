//
//  UIScreen+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI


extension UIScreen {
    static func widthPer(percentage: Double) -> CGFloat {
        return UIScreen.main.bounds.width * CGFloat(percentage / 100)
    }

    static func heightPer(percentage: Double) -> CGFloat {
        return UIScreen.main.bounds.height * CGFloat(percentage / 100)
    }
}
