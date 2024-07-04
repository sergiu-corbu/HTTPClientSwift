//
//  HTTPError.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

struct HTTPError: Error {

    let statusCode: Int
    let type: HTTPErrorType
    var errorCodeString: String?
    var errors: [String]?
    private let message: String?

    static var invalidHTTPStatusCode: Self {
        HTTPError(statusCode: -1, type: .invalidHTTPStatusCode(-1), message: nil)
    }

    static var invalidUserSession: Self {
        HTTPError(statusCode: -1, type: .invalidRequestResponse, message: "The user is not authenticated")
    }

    static var unknown: Self {
        HTTPError(statusCode: -1, type: .unknown, message: nil)
    }

    static var missingData: Self {
        HTTPError(statusCode: -1, type: .missingData, message: nil)
    }

    static var maxRetryAttemptsReached: Self {
        HTTPError(statusCode: -1, type: .maxRetryAttemptsReached, message: nil)
    }

    static var invalidErrorFormat: Self {
        HTTPError(statusCode: -1, type: .invalidErrorFormat, message: nil)
    }

    static var appUpdateRequired: Self {
        HTTPError(statusCode: -1, type: .appUpdateRequired, message: nil)
    }
}

extension HTTPError: Decodable {

    private enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorCodeString = "code"
        case message
        case errors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.message = try container.decode(String.self, forKey: .message)
        self.errorCodeString = try? container.decodeIfPresent(String.self, forKey: .errorCodeString)
        self.errors = try container.decodeIfPresent(Array<String>.self, forKey: .errors)
        self.type = .invalidRequestResponse
    }
}

extension HTTPError: LocalizedError {

    var errorDescription: String? {
        switch type {
        case .invalidHTTPStatusCode(let code):
            return "Response status code was unacceptable: \(code)."
        case .invalidRequestResponse:
            return errors?.first ?? message
        case .missingData:
            return "Could not access response data."
        case .maxRetryAttemptsReached:
            return "Maximum retry attempts have been reached."
        case .unknown:
            return "Unknown error"
        case .appUpdateRequired:
            return "Upating the app is required"
        case .invalidErrorFormat:
            return "We have encountered an unexpected error"
        }
    }
}

extension HTTPError {

    enum HTTPErrorType {
        case appUpdateRequired
        case invalidRequestResponse
        case invalidHTTPStatusCode(Int)
        case missingData
        case maxRetryAttemptsReached
        case invalidErrorFormat
        case unknown
    }
}
