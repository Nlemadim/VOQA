//
//  QuizDetailPage+Subviews+Ext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/25/24.
//

import Foundation
import SwiftUI

extension QuizDetailPage {
    @ViewBuilder
    internal var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerSection
            buttonsSection
            categorySection
            aboutSection
            footerSection
        }
    }
    
    @ViewBuilder
    internal var headerSection: some View {
        VStack(spacing: 5) {
            Image(package.titleImage)
                .resizable()
                .frame(width: 250, height: 250)
                .cornerRadius(20)
                .padding()
            
            Text(package.title)
                .lineLimit(4, reservesSpace: false)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .hAlign(.center)
            
            Text(package.edition.descr)
                .font(.caption)
                .foregroundStyle(.secondary)
                .hAlign(.center)
            
            if let curator = package.curator {
                Text("Curated by: " + curator)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .hAlign(.center)
            }
            
            if let users = package.users {
                Text("Users: \(users)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .hAlign(.center)
            }
            
            if let rating = package.rating {
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        if index <= rating {
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                                .foregroundStyle(.yellow)
                        } else {
                            Image(systemName: "star")
                                .imageScale(.small)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .hAlign(.center)
    }
    
    @ViewBuilder
    internal var buttonsSection: some View {
        VStack(alignment: .leading) {
            PlaySampleButton(playAction: { })
                .padding(.horizontal)
                .padding()
                .padding(.top)
                
            
            PlainClearButton(color: generator.dominantBackgroundColor, label: "Download") {
                
            }
            .padding(.horizontal)
            .padding(5)
        }
        .padding(.horizontal)
        .offset(y: -40)
    }
    
    @ViewBuilder
    internal var categorySection: some View {
        VStack {
            Text("Category")
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .hAlign(.leading)
            
            HStack(spacing: 16.0) {
                ForEach(package.category, id: \.self) { category in
                    Text(category.descr)
                        .font(.system(size: 10))
                        .fontWeight(.light)
                        .lineLimit(1)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.5)
                        )
                }
            }
            .hAlign(.leading)
            .multilineTextAlignment(.leading)
        }
        .padding()
    }
    
    @ViewBuilder
    internal var aboutSection: some View {
        VStack {
            Text("About \(package.title)")
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .hAlign(.leading)
            
            Divider()
            
            Text(package.summaryDesc)
                .font(.subheadline)
                .fontWeight(.light)
                .hAlign(.leading)
        }
        .padding()
        .padding(.bottom)
    }
    
    @ViewBuilder
    internal var footerSection: some View {
        Rectangle()
            .fill(.black)
            .frame(height: 100)
    }
}
