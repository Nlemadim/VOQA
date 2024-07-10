//
//  CGFloat+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import  SwiftUI

extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per;
        //screenWidth: 375 * 0.5
    }
    
    static func heightPer(per: Double) -> Double {
        return screenWidth * per;
        //screenWidth: 375 * 0.5
    }
}
