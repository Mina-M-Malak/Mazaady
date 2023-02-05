//
//  Mazaady.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import Foundation

enum Mazaady {
    case getAllCars
    case getProperties(subcategoryId: Int)
    case getChildOptions(optionId: Int)
}

extension Mazaady: Endpoint {
    var base: String {
        return Bundle.main.baseURL
    }
    
    var urlSubFolder: String {
        return Bundle.main.urlSubFolder
    }
    
    var prefix: String {
        return Bundle.main.apiPrefix
    }
    
    var path: String {
        switch self {
        case .getAllCars:
            return "get_all_cats"
        case .getProperties:
            return "properties"
        case .getChildOptions(let optionId):
            return "get-options-child/\(optionId)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getProperties(let subcategoryId):
            return [URLQueryItem(name: "cat", value: "\(subcategoryId)")]
        default:
            return []
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default :
            return .get
        }
    }
    
    var headers : [httpHeader] {
        var httpHeaders: [httpHeader] = [httpHeader(key: "private-key", value: "3%o8i}_;3D4bF]G5@22r2)Et1&mLJ4?$@+16")]
        switch self {
        default:
            return httpHeaders
        }
    }
    
    var body: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
}

extension URLRequest {
    mutating func addHeaders(_ Headers:[httpHeader]){
        for Header in Headers {
            self.addValue(Header.value, forHTTPHeaderField: Header.key)
        }
    }
}

extension Bundle {
    var baseURL: String {
        return object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    }
    
    var urlSubFolder: String {
        return object(forInfoDictionaryKey: "URLSubFolder") as? String ?? ""
    }
    
    var apiPrefix: String {
        return "/"
    }
}
