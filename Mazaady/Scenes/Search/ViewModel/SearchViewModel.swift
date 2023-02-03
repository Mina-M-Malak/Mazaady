//
//  SearchViewModel.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import Foundation

class SearchViewModel {
    
    var loadingState: ((_ isShowing: Bool) -> ())?
    
    func fetchCategories(complation: @escaping (_ result: RequestState<[Category]>)->()) {
        loadingState?(true)
        APIRoute.shared.fetch(with: .getAllCars, model: APIResponse<CategoriesData>.self) { [weak self] (response) in
            self?.loadingState?(false)
            switch response{
            case .success(let data):
                complation(.success(data.data.categories))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
    
    func fetchProperties(subcategoryId: Int,complation: @escaping (_ result: RequestState<[Property]>)->()) {
        loadingState?(true)
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: subcategoryId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            self?.loadingState?(false)
            switch response{
            case .success(let data):
                complation(.success(data.data))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
    
    func fetchChildOptions(propertyId: Int,complation: @escaping (_ result: RequestState<[Property]>)->()) {
        loadingState?(true)
        APIRoute.shared.fetch(with: .getChildOptions(optionId: propertyId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            self?.loadingState?(false)
            switch response{
            case .success(let data):
                complation(.success(data.data))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
}
