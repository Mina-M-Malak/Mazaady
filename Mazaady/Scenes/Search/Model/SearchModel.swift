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
    var selectedOptionIndex: Int?
    var otherValue: String?
    var parentId: Int?
}

struct Option: Codable{
    let id: Int
    let name: String
    let hasChild: Bool
    
    enum CodingKeys: String , CodingKey {
        case id , name
        case hasChild = "child"
    }
}
