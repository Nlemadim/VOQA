//
//  PacketCover.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/27/24.
//

import Foundation

struct PacketCover: Identifiable, Hashable {
    var id: UUID
    var title: String
    var titleImage: String
    var summaryDesc: String
    var rating: Int
    var numberOfRatings: Int
    var edition: String
    var curator: String
    var users: Int
    
    init(id: UUID = UUID(), title: String, titleImage: String, summaryDesc: String, rating: Int, numberOfRatings: Int, edition: String, curator: String, users: Int) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.summaryDesc = summaryDesc
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.edition = edition
        self.curator = curator
        self.users = users
    }
    
    static func == (lhs: PacketCover, rhs: PacketCover) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


