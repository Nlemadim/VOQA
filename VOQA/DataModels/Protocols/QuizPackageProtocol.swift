//
//  QuizPackageProtocol.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation

protocol QuizPackage {
    var title: String { get }
    var titleImage: String { get }
    var topics: [Topic] { get }
    var audioQuiz: AudioQuiz? { get }
}
