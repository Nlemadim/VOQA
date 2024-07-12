//
//  HomepageConfigProtocols.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

protocol VoqaConfiguration: Decodable {
    var category: String { get }
    var subtitle: String { get }
    var quizzes: [Voqa] { get }
}

protocol VoqaItem: Decodable {
    var name: String { get }
    var acronym: String { get }
    var about: String { get }
    var imageUrl: String { get }
    var rating: Int? { get }
    var curator: String? { get }
    var users: Int? { get }
}

