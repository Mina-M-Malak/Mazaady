//
//  SearchSections.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import Foundation

enum SearchSections: CaseIterable {
    case category
    case subcategory
    case option
    
    var placeholder: String {
        switch self{
        case .category:
            return "Category"
        case .subcategory:
            return "Subcategory"
        case .option:
            return ""
        }
    }
}
