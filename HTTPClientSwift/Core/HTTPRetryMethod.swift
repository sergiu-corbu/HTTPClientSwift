//
//  HTTPRetryStrategy.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

enum HTTPRetryMethod {
    case immediate
    case delayed(_ delay: TimeInterval)
    case afterRequest(
        _ request: HTTPRequest, _ delay: TimeInterval, fallbackResponseHandler: ((HTTPResponse) -> HTTPResponse)?)
    case afterTask(
        _ delay: TimeInterval, _ task: (_ originalRequest: HTTPRequest) async throws -> Void,
        _ errorHandler: (_ error: Error) async -> Void)

    func retryDelay(forRequest request: HTTPRequest) -> TimeInterval {
        if case .delayed(let delay) = self {
            return delay
        }
        return 0
    }
}
