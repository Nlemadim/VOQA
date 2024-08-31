//
//  PageLinkView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import Foundation
import SwiftUI

struct PageLinkView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(title == "Delete My Account" ? .red : .white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
    }
}
