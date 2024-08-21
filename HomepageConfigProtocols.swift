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
    var quizTitle: String { get }
    var acronym: String { get }
    var about: String { get }
    var imageUrl: String { get }
    var rating: Int { get }
    var curator: String { get }
    var users: Int { get }
    var title: String { get }
    var titleImage: String { get }
    var categories: [String] { get }
    var colors: Colors { get }
    var ratings: Int { get }
}




