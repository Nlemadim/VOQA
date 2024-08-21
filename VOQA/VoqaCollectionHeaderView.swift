//
//  VoqaCollectionHeaderView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import Foundation
import SwiftUI

// Header view for the collection category and subtitle
struct VoqaCollectionHeaderView: View {
    var category: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(category.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5)
                .padding(.horizontal)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(subtitle)
                .font(.footnote)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .padding(.vertical)
    }
}
