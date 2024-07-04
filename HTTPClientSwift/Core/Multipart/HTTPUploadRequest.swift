//
//  HTTPUploadRequest.swift
//  HTTPClientSwift
//
// Created by Sergiu Corbu
//

import Foundation

enum UploadScope: String {

    case profilePicture = "userProfilePicture"
    case videoShow

    var mimeType: MimeType {
        switch self {
        case .profilePicture: return .jpegImage
        case .videoShow: return .video
        }
    }
}

enum MimeType: String {
    case jpegImage = "image/jpg"
    case video = "video/mp4"
}

let UploadImageMaxSize: UInt = 1600  // pixel
let JPEGCompressionQuality = 0.8

struct UploadRequest: Codable {
    let url: URL
    let fields: [String: String]
}
