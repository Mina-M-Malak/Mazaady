//
//  SearchViewController.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum Sections: CaseIterable{
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
    
    @IBOutlet weak var searchTableView: UITableView!
    
    private var selectedCategoryIndex: Int?{
        didSet{
            if let subcategorySectionIndex = sections.firstIndex(where: {$0 == .subcategory}) {
                searchTableView.reloadRows(at: [IndexPath(row: 0, section: subcategorySectionIndex)], with: .automatic)
            }
        }
    }
    
    private var selectedSubcategoryIndex: Int?{
        didSet{
            fetchProperties()
        }
    }
    
    private var categories: [Category] = []{
        didSet{
            searchTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    private var properties: [Property] = []{
        didSet{
            sections.append(contentsOf: Sections.AllCases(repeating: .option, count: properties.count))
            searchTableView.reloadData()
        }
    }
    
    private var sections: [Sections] = [.category,.subcategory]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        title = "Search"
        searchTableView.registerCell(tabelViewCell: SearchInputTableViewCell.self)
    }
    
    private func fetchData() {
        APIRoute.shared.fetch(with: .getAllCars, model: APIResponse<CategoriesData>.self) { [weak self] (response) in
            switch response{
            case .success(let data):
                self?.categories = data.data.categories
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchProperties() {
        guard let selectedCategoryIndex = selectedCategoryIndex , let selectedSubcategoryIndex = selectedSubcategoryIndex else { return }
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: categories[selectedCategoryIndex].subcategories[selectedSubcategoryIndex].id), model: APIResponse<[Property]>.self) { [weak self] (response) in
            switch response{
            case .success(let data):
                self?.properties = data.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        let cell = searchTableView.dequeueCell(tabelViewCell: SearchInputTableViewCell.self, indexPath: indexPath)
        cell.setData(section: sections[indexPath.section])
        switch sections[indexPath.section] {
        case .category:
            cell.setCategory(categories: categories,selectedCategoryindex: selectedCategoryIndex)
            cell.didSelectItem = { [weak self] (index) in
                self?.selectedCategoryIndex = index
                self?.selectedSubcategoryIndex = nil
            }
        case .subcategory:
            if let selectedCategoryIndex = selectedCategoryIndex {
                cell.setSubcategory(subcategories: categories[selectedCategoryIndex].subcategories,selectedSubcategoryindex: selectedSubcategoryIndex)
            }
            cell.didSelectItem = { [weak self] (index) in
                self?.selectedSubcategoryIndex = index
            }
        case .option:
            cell.setOption(option: properties[indexPath.section - 2])
            cell.didSelectItem = { [weak self] (index) in
                print("Here")
            }
        }
        
        return cell as! t
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section]{
        case .category , .subcategory:
            return 1
        case .option:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}
