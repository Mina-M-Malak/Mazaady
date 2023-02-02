//
//  SearchViewModel.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import Foundation

class SearchViewModel {
    
    var showLoader: ((_ isLoading: Bool)->())?
    var getCategories: ((_ categories: [Category]) -> ())?
    var getProperties: ((_ properties: [Property]) -> ())?
    var getChildOptions: ((_ properties: [Property]) -> ())?
    
    func fetchData() {
        showLoader?(true)
        APIRoute.shared.fetch(with: .getAllCars, model: APIResponse<CategoriesData>.self) { [weak self] (response) in
            self?.showLoader?(false)
            switch response{
            case .success(let data):
                self?.getCategories?(data.data.categories)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchProperties(subcategoryId: Int) {
        self.showLoader?(true)
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: subcategoryId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            self?.showLoader?(false)
            switch response{
            case .success(let data):
                self?.getProperties?(data.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchChildOptions(propertyId: Int) {
        showLoader?(true)
        APIRoute.shared.fetch(with: .getChildOptions(optionId: propertyId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            self?.showLoader?(false)
            switch response{
            case .success(let data):
                self?.getChildOptions?(data.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
