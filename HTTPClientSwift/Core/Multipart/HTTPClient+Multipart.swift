//
//  HTTPClient + Multipart.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

extension HTTPClient {

    struct MultipartUpload {

        let uploadResource: UploadResourceType
        let fileName: String
        let uploadScope: UploadScope
        let owner: String?

        struct UploadKeys {
            static let fileName = "name"
            static let uploadScope = "scope"
            static let mimeType = "mimetype"
            static let owner = "owner"
        }

        enum UploadResourceType {
            case data(Data)
            case file(URL)
        }
    }
}

typealias Multipart = HTTPClient.MultipartUpload

extension HTTPClient {

    func upload(request: UploadRequest, multipart: Multipart, uploadProgress: ((Double) -> Void)?) async throws {
        let boundaryString = createBoundary()
        let multipartHeaderValue = HeaderFields.multipartHeader + " boundary=\(boundaryString)"

        switch multipart.uploadResource {
        case .data(_):
            // Create the HTTP Request from the serverURL
            var uploadRequest = URLRequest(url: request.url)
            uploadRequest.httpMethod = HTTPMethod.post.rawValue
            uploadRequest.setValue(multipartHeaderValue, forHTTPHeaderField: HeaderFields.contentType)

            // Set the body data of the request
            var uploadData = createHTTPBody(boundary: boundaryString, with: request.fields)
            // Set the properties of the multipart
            addMultipartData(multipart: multipart, for: &uploadData, boundary: boundaryString)
            closeHTTPBodyWithBoundary(for: &uploadData, boundary: boundaryString)
            try await session.upload(for: uploadRequest, with: uploadData)
        case .file(let resourceFileURL):
            break  //TODO: implement in a future iteration
        }
    }

    private func createHTTPBody(boundary: String, with parameters: [String: String]) -> Data {
        var data = Data()

        for (key, value) in parameters {
            let values = [
                "\r\n--\(boundary)\r\n",
                "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n",
                value,
            ]
            for value in values {
                if let dataValue = value.data(using: .utf8) {
                    data.append(dataValue)
                }
            }
        }

        return data
    }

    private func createBoundary() -> String {
        var uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        uuid = uuid.map { $0.lowercased() }.joined()
        let boundary = String(repeating: "-", count: 15) + uuid + "\(Int(Date.timeIntervalSinceReferenceDate))"

        return boundary
    }

    private func addMultipartData(multipart: Multipart, for data: inout Data, boundary: String) {
        if let boundaryData = "\r\n--\(boundary)\r\n".data(using: .utf8) {
            data.append(boundaryData)
        }
        let values = [
            "Content-Disposition: form-data; name=\"file\"; filename=\"\(multipart.fileName)\"\r\n",
            "Content-Type: \(multipart.uploadScope.mimeType.rawValue)\r\n\r\n",
        ]
        for value in values {
            if let dataValue = value.data(using: .utf8) {
                data.append(dataValue)
            }
        }

        if case .data(let uploadResourceData) = multipart.uploadResource {
            data.append(uploadResourceData)
        }
    }

    private func closeHTTPBodyWithBoundary(for data: inout Data, boundary: String) {
        let boundaryData = "\r\n--\(boundary)--\r\n".data(using: .utf8)
        if let boundaryData = boundaryData {
            data.append(boundaryData)
        }
    }
}
