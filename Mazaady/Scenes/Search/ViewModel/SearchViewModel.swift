//
//  SearchViewModel.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import Foundation

class SearchViewModel {
    
    var loadingState: ((_ isShowing: Bool) -> ())?
    var didUpdateProperties: (() ->())?
    var properties: [Property] = []
    
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
    
    func fetchProperties(subcategoryId: Int,complation: @escaping (_ result: RequestState<[Property]?>)->()) {
        loadingState?(true)
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: subcategoryId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            self?.loadingState?(false)
            switch response{
            case .success(let data):
                self?.properties = data.data
                complation(.success(nil))
            case .failure(let error):
                complation(.failure(error.localizedDescription))
            }
        }
    }
    
    private func fetchChildOptions(propertyId: Int,optionId: Int) {
        loadingState?(true)
        APIRoute.shared.fetch(with: .getChildOptions(optionId: optionId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.loadingState?(false)
            switch response{
            case .success(let data):
                strongSelf.setupPropertioes(propertyId: propertyId,properties: data.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupPropertioes(propertyId: Int?,properties: [Property]) {
        var properties = properties
        if let propertyId = propertyId {
            for (index,_) in properties.enumerated() {
                properties[index].parentId = propertyId
            }
        }
        let insertIndex = (self.properties.firstIndex(where: {$0.id == propertyId}) ?? 0) + 1
        self.properties.insert(contentsOf: properties, at: insertIndex)
        didUpdateProperties?()
    }
    
    func didSelectProperty(propertyIndex: Int,optionIndex: Int) {
        guard !properties[propertyIndex].options.isEmpty else { return }
        if properties[propertyIndex].options.count > optionIndex, properties[propertyIndex].options[optionIndex].hasChild {
            // get childs
            fetchChildOptions(propertyId: properties[propertyIndex].id,optionId: properties[propertyIndex].options[optionIndex].id)
        }
        let propertyId = properties[propertyIndex].id
        guard !properties.filter({$0.parentId == propertyId}).isEmpty else { return }
        properties.filter({$0.parentId == propertyId}).map({$0.id}).forEach { (id) in
            filterProperties(propertyId: id)
        }
        didUpdateProperties?()
    }
    
    private func filterProperties(propertyId: Int) {
        let ids = properties.filter({$0.parentId == propertyId}).map({$0.id})
        guard !ids.isEmpty else {
            properties.removeAll(where: {$0.id == propertyId})
            return
        }
        
        ids.forEach { (id) in
            filterProperties(propertyId: id)
            properties.removeAll(where: {$0.id == propertyId})
        }
    }
}
