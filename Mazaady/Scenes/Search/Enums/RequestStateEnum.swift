//
//  RequestStateEnum.swift
//  Mazaady
//
//  Created by Mina Malak on 03/02/2023.
//

import Foundation

enum RequestState<t: Decodable>{
    case loading
    case success(t)
    case failure(String)
}
