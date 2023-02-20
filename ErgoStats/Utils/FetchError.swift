//
//  FetchError.swift
//  ErgoStats
//
//  Created by Alin Chitas on 10.02.2023.
//

import Foundation

enum FetchError: Error, LocalizedError {
    case invalidUrl
    case serverError
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return ""
        case .serverError:
            return "There was an error with the server. Please try again later"
        case .invalidData:
            return "The data is invalid. Please try again later"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
