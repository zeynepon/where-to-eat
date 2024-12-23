//
//  View+KeyboardPublisher.swift
//  WhereToEat
//
//  Created by Zeynep on 23/12/2024.
//

import SwiftUI
import Combine

extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter
                .default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            NotificationCenter
                .default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false })
        .eraseToAnyPublisher()
    }
}
