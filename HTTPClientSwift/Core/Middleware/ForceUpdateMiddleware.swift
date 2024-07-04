import Combine
//
//  ForceUpdateMiddleware.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//
import Foundation

class ForceUpdateMiddleware: HTTPMiddleware {
    let forceUpdatePublisher = PassthroughSubject<Void, Never>()

    func shouldProcessResponse(_ response: HTTPResponse) -> Bool {
        return response.httpURLResponse?.statusCode == ErrorCodes.forceUpdate
    }

    func processResponse(_ response: HTTPResponse) -> HTTPResponseProcessingResult {
        forceUpdatePublisher.send()
        return .fail(HTTPError.appUpdateRequired)
    }

    func shouldProcessRequest(_ httpRequest: HTTPRequest) -> Bool {
        return false
    }
    func processRequest(_ request: HTTPRequest) -> HTTPRequest {
        return request
    }
}

extension ForceUpdateMiddleware {
    struct ErrorCodes {
        static let forceUpdate: Int = 409
    }
}
