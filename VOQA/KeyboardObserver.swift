//
//  KeyboardObserver.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/10/24.
//

import UIKit
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).map { _ in false })
            .subscribe(on: RunLoop.main)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
