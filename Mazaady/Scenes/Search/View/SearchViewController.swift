//
//  SearchViewController.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var selectedCategoryIndex: Int?{
        didSet{
            if sections.contains(.option){
                sections.removeAll(where: {$0 == .option})
                searchTableView.reloadData()
            }
            else if let subcategorySectionIndex = sections.firstIndex(where: {$0 == .subcategory}) {
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
    private var properties: [Property] = []
    private var sections: [SearchSections] = [.category,.subcategory]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        title = "Search"
        
        refreshControl.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        
        searchTableView.refreshControl = refreshControl
        searchTableView.registerCell(tabelViewCell: SearchInputTableViewCell.self)
        
        searchTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func fetchData() {
        self.handleRefreshControl(true)
        APIRoute.shared.fetch(with: .getAllCars, model: APIResponse<CategoriesData>.self) { [weak self] (response) in
            self?.handleRefreshControl(false)
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
        sections.removeAll(where: {$0 == .option})
        self.handleRefreshControl(true)
        APIRoute.shared.fetch(with: .getProperties(subcategoryId: categories[selectedCategoryIndex].subcategories[selectedSubcategoryIndex].id), model: APIResponse<[Property]>.self) { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.handleRefreshControl(false)
            switch response{
            case .success(let data):
                strongSelf.properties = data.data
                strongSelf.sections.append(contentsOf: SearchSections.AllCases(repeating: .option, count: strongSelf.properties.count))
                strongSelf.searchTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchChildOptions(propertyId: Int,propertyIndex: Int) {
        self.handleRefreshControl(true)
        APIRoute.shared.fetch(with: .getChildOptions(optionId: propertyId), model: APIResponse<[Property]>.self) { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.handleRefreshControl(false)
            switch response{
            case .success(let data):
                strongSelf.properties[propertyIndex - 2].child = data.data
                strongSelf.searchTableView.reloadSections(IndexSet(integer: propertyIndex), with: .automatic)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func handleRefreshControl(_ isRefreshing:Bool) {
        if isRefreshing {
            refreshControl.beginRefreshing()
            view.isUserInteractionEnabled = false
        } else {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
                view.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func handleRefresher() {
        refreshControl.endRefreshing()
    }
    
    func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        let cell = searchTableView.dequeueCell(tabelViewCell: SearchInputTableViewCell.self, indexPath: indexPath)
        cell.setData(section: sections[indexPath.section])
        cell.reloadCellHeight = { [weak self] in
            self?.searchTableView.beginUpdates()
            self?.searchTableView.endUpdates()
        }
        switch sections[indexPath.section] {
        case .category:
            cell.setCategory(categories: categories,selectedCategoryindex: selectedCategoryIndex)
            cell.didSelectItem = { [weak self] (index) in
                self?.selectedSubcategoryIndex = nil
                self?.selectedCategoryIndex = index
            }
        case .subcategory:
            if let selectedCategoryIndex = selectedCategoryIndex {
                cell.setSubcategory(subcategories: categories[selectedCategoryIndex].subcategories,selectedSubcategoryindex: selectedSubcategoryIndex)
            }
            cell.didSelectItem = { [weak self] (index) in
                guard self?.selectedSubcategoryIndex != index else { return }
                self?.selectedSubcategoryIndex = index
            }
        case .option:
            let section = indexPath.section - 2
            if let option = (indexPath.row == 0) ? properties[section] : properties[section].child?[indexPath.row - 1] {
                cell.setOption(property: option,selectedOptionIndex: option.selectedOptionIndex, showOther: option.selectedOptionIndex == -1)
            }
            
            cell.didSelectItem = { [weak self] (index) in
                if indexPath.row == 0 {
                    if (self?.properties[section].options.count ?? 0) > index {
                        self?.properties[section].selectedOptionIndex = index
                        if (self?.properties[section].options[index].child ?? false) , let propertyId = self?.properties[section].options[index].id {
                            // get childs
                            self?.fetchChildOptions(propertyId: propertyId, propertyIndex: indexPath.section)
                        }
                    }
                    else{
                        self?.properties[section].selectedOptionIndex = -1
                    }
                }
                else{
                    if (self?.properties[section].child?[indexPath.row - 1].options.count ?? 0) > index {
                        self?.properties[section].child?[indexPath.row - 1].selectedOptionIndex = index
                    }
                    else{
                        self?.properties[section].child?[indexPath.row - 1].selectedOptionIndex = -1
                    }
                }
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
            return (properties[section - 2].child?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}
