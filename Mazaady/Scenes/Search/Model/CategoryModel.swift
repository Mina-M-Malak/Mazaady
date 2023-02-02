//
//  CategoryModel.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import Foundation

struct CategoriesData: Decodable{
    let categories: [Category]
}

struct Category: Decodable{
    let id: Int
    let name: String
    let subcategories: [Subcategory]
    
    enum CodingKeys: String , CodingKey {
        case id , name
        case subcategories = "children"
    }
}

struct Subcategory: Decodable{
    let id: Int
    let name: String
}

struct Property: Decodable{
    let id: Int
    let name: String
    let options: [Option]
    var child: [Property]?
    var selectedOptionIndex: Int?
}

struct Option: Decodable{
    let id: Int
    let name: String
    let slug: String
    let child: Bool
}
