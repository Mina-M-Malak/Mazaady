//
//  Endpoint.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

protocol Endpoint {
    var base: String { get }
    var urlSubFolder: String { get }
    var path: String { get }
    var prefix: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = urlSubFolder + prefix + path
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        let request =  URLRequest(url: url)
        return request
    }
}
