//
//  Result.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import Foundation

struct APIResponse<R: Decodable>: Decodable {
    var pagination: Bool?
    var data: R
    var message: String?
}

struct GeneralErrorMessage: Decodable {
    var errors: [ErrorObjects]
}

struct ErrorObjects: Decodable {
    var message: String
}

struct httpHeader:Decodable {
    var key:String
    var value:String
}
