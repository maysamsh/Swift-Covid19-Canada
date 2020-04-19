//
//  NetworkManager+Failure.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-02.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

enum Failure: LocalizedError {
    case failedToDeliver(message: String)
    case customMessage(message: String)
    case invalidResponse
    case invalidDataReponse
    case invalidCSVData
    
    var localizedDescription: String? {
        switch self {
        case let .failedToDeliver(message), let .customMessage(message: message):
            return message
        case .invalidResponse:
            return "Invalid response received, try again later."
        case .invalidDataReponse:
            return "Invalid data response, contact the developer."
        case .invalidCSVData:
            return "Failed to read CSV Data."
        }
    }
    
    var errorDescription: String? {
        switch self {
        case let .failedToDeliver(message), let .customMessage(message: message):
            return message
        case .invalidResponse:
            return "Invalid response received, try again later."
        case .invalidDataReponse:
            return "Invalid data response, contact the developer."
        case .invalidCSVData:
            return "Failed to read CSV Data."
        }
    }
}
