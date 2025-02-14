//
//  HTTPClient+QueryComponents.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

extension HTTPClient {

    func createQueryItems(from parameters: [String: Any], encodingStrategy: EncodingStrategy) -> [URLQueryItem] {
        var components = [(String, String)]()
        for (key, value) in parameters {
            components += queryComponents(fromKey: key, value: value, encodingStrategy: encodingStrategy)
        }
        return components.map { URLQueryItem(name: $0.0, value: $0.1) }
    }
}

//MARK: - Utils
extension HTTPClient {

    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    fileprivate func queryComponents(
        fromKey key: String, value: Any, encodingStrategy: EncodingStrategy
    ) -> [(String, String)] {
        var components = [(String, String)]()
        let key_ = escape(key)

        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(
                    fromKey: "\(key)[\(nestedKey)]", value: value, encodingStrategy: encodingStrategy)
            }
        case let array as [Any]:
            for value in array {
                components += queryComponents(
                    fromKey: encodingStrategy.arrayEncoding.encode(key: key),
                    value: value,
                    encodingStrategy: encodingStrategy
                )
            }
        case let intValue as Int:
            components.append((key_, escape(String(intValue))))
        case let bool as Bool:
            components.append((key_, escape(encodingStrategy.boolEncoding.encode(value: bool))))
        default:
            components.append((key_, escape("\(value)")))
        }
        return components
    }

    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    fileprivate func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"  // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""

        let batchSize = 50
        var index = string.startIndex

        while index != string.endIndex {
            let startIndex = index
            let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
            let range = startIndex..<endIndex

            let substring = string[range]

            escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)

            index = endIndex
        }
        return escaped
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
