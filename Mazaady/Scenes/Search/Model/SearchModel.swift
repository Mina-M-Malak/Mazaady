//
//  SearchModel.swift
//  Mazaady
//
//  Created by Mina Malak on 03/02/2023.
//

import Foundation

struct CategoriesData: Codable{
    let categories: [Category]
}

struct Category: Codable{
    let id: Int
    let name: String
    let subcategories: [Subcategory]
    
    enum CodingKeys: String , CodingKey {
        case id , name
        case subcategories = "children"
    }
}

struct Subcategory: Codable{
    let id: Int
    let name: String
}

struct Property: Codable{
    let id: Int
    let name: String
    var options: [Option]
    var child: [Property]?
    var selectedOptionIndex: Int?
    var otherValue: String?
}

struct Option: Codable{
    let id: Int
    let name: String
    let child: Bool
}
