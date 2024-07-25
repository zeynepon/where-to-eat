//
//  Publisher+SinkSupport.swift
//  WhereToEat
//
//  Created by Zeynep on 25/07/2024.
//

import Combine

extension Publisher where Self.Failure == Never {
    func sink(receiveValue: @escaping ((Self.Output) async -> Void)) -> AnyCancellable {
        sink { value in
            Task {
                await receiveValue(value)
            }
        }
    }
}
