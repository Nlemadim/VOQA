//
//  Errors.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation

protocol AppError: Error, Identifiable {
    var id: UUID { get }
    var title: String? { get }
    var message: String? { get }
    var errorType: ErrorType? { get }
}

enum ErrorType: Equatable {
    case databaseError(DatabaseErrorType)
    case connectionError(ConnectionErrorType)
}

enum DatabaseErrorType: Error {
    case downloadError
    case saveError
    case accessError
}

enum ConnectionErrorType: Error {
    case noConnection
    case connectionLost
    case connectionRestored
}

struct DatabaseError: AppError {
    var id = UUID()
    var title: String?
    var message: String?
    var errorType: ErrorType?

    init(title: String? = nil, message: String? = nil, errorType: DatabaseErrorType? = nil) {
        self.title = title
        self.message = message
        self.errorType = errorType.map { .databaseError($0) }
    }
}

struct ConnectionError: AppError {
    var id = UUID()
    var title: String?
    var message: String?
    var errorType: ErrorType?

    init(title: String? = nil, message: String? = nil, errorType: ConnectionErrorType? = nil) {
        self.title = title
        self.message = message
        self.errorType = errorType.map { .connectionError($0) }
    }
}
