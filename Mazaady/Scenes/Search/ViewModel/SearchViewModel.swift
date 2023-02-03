//
//  SearchViewModel.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import Foundation

class SearchViewModel {
    
    func fetchCategories(complation: @escaping (_ result: RequestState<[Category]>)->()) {
        complation(.loading)
        APIRoute.shared.fetch(with: .getAllCars, model: APIResponse<CategoriesData>.self) { (response) in
            switch response{
            case .success(let data):
                complation(.success(data.data.categories))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
    
    func fetchProperties(subcategoryId: Int,complation: @escaping (_ result: RequestState<[Property]>)->()) {
        complation(.loading)
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: subcategoryId), model: APIResponse<[Property]>.self) { (response) in
            switch response{
            case .success(let data):
                complation(.success(data.data))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
    
    func fetchChildOptions(propertyId: Int,complation: @escaping (_ result: RequestState<[Property]>)->()) {
        complation(.loading)
        APIRoute.shared.fetch(with: .getChildOptions(optionId: propertyId), model: APIResponse<[Property]>.self) { (response) in
            switch response{
            case .success(let data):
                complation(.success(data.data))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
}
