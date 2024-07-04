//
//  HTTPClient+ParameterEncoding.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

extension HTTPClient {

    struct EncodingStrategy {
        let parameterEncoding: ParameterEncoding
        var arrayEncoding: ArrayEncodingStrategy = .brackets
        var boolEncoding: BoolEncodingStrategy = .literal

        static let standardJSON = EncodingStrategy(parameterEncoding: .json)
        static let standardURL = EncodingStrategy(parameterEncoding: .url)
    }

    enum ParameterEncoding {
        case json
        case url

        var headerValue: String {
            switch self {
            case .url:
                return "application/x-www-form-urlencoded; charset=utf-8"
            case .json:
                return "application/json"
            }
        }
    }

    /// Configures how `Array` parameters are encoded.
    ///
    /// - brackets:        An empty set of square brackets is appended to the key for every value.
    ///             This is the default behavior.
    /// - noBrackets:    No brackets are appended. The key is encoded as is.
    enum ArrayEncodingStrategy {
        case brackets, noBrackets

        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }

    /// Configures how `Bool` parameters are encoded.
    ///
    /// - numeric:         Encode `true` as `1` and `false` as `0`. This is the default behavior.
    /// - literal:         Encode `true` and `false` as string literals.
    enum BoolEncodingStrategy {
        case numeric, literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
}
