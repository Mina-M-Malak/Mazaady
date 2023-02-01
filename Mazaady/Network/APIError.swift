//
//  APIError.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case unauthorized
    case responseUnsuccessful
    case jsonParsingFailure
    case message(value: GeneralErrorMessage)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Please check your connection and try again later"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .message(let value):
            guard let errorMessage = value.errors.first else { return "No Error Message"}
            return errorMessage.message
        case .unauthorized:
            return "unauthorized"
        }
    }
}
