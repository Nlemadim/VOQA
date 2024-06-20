//
//  DatabaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()

    @Published var currentError: DatabaseError?
    @Published var showFullPageError: Bool = false

    private init() {}

    func handleError(_ error: DatabaseError) {
        self.currentError = error
        if let errorType = error.errorType {
            switch errorType {
            case .databaseError(let dbError):
                switch dbError {
                case .downloadError, .saveError:
                    self.showFullPageError = false
                case .accessError:
                    self.showFullPageError = true
                }
            case .connectionError:
                // Handle connection errors if necessary
                break
                
            default:
                break
            } 
        }
    }
}
