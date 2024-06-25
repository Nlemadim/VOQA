//
//  DataService+Protocols.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

/// A protocol to fetch data for any model object.
protocol DataFetchable {
    associatedtype ModelType
    func fetchAll(completion: @escaping (Result<[ModelType], Error>) -> Void)
    func fetchById(_ id: UUID, completion: @escaping (Result<ModelType, Error>) -> Void)
}

/// A protocol specifically for handling downloads.
protocol Downloadable {
    var id: UUID { get }
    var downloadUrl: String { get }
    func download(completion: @escaping (Result<Data, Error>) -> Void)
}

/// A specialized protocol for handling audio downloads in questions.
protocol AudioDownloadable {
    var audioUrl: String { get }
    func downloadAudio(completion: @escaping (Result<URL, Error>) -> Void)
}
