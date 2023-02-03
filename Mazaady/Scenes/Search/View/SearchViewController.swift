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
    
    let viewModel = SearchViewModel()
    
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
            guard let selectedCategoryIndex = selectedCategoryIndex , let selectedSubcategoryIndex = selectedSubcategoryIndex else { return }
            sections.removeAll(where: {$0 == .option})
            let subcategoryId = categories[selectedCategoryIndex].subcategories[selectedSubcategoryIndex].id
            viewModel.fetchProperties(subcategoryId: subcategoryId)
        }
    }
    
    private var categories: [Category] = []{
        didSet{
            searchTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    private var properties: [Property] = []
    private var sections: [SearchSections] = [.category,.subcategory]
    private var loadedSectionIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setObservers()
        viewModel.fetchData()
    }
    
    private func setupUI() {
        title = "Search"
        
        refreshControl.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        
        searchTableView.refreshControl = refreshControl
        searchTableView.registerCell(tabelViewCell: SearchInputTableViewCell.self)
        
        searchTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setObservers() {
        viewModel.showLoader = { [weak self] (isLoading) in
            self?.handleRefreshControl(isLoading)
        }
        
        viewModel.getCategories = { [weak self] (categories) in
            self?.categories = categories
        }
        
        viewModel.getProperties = { [weak self] (properties) in
            guard let strongSelf = self else { return }
            strongSelf.properties = properties
            strongSelf.sections.append(contentsOf: SearchSections.AllCases(repeating: .option, count: strongSelf.properties.count))
            strongSelf.searchTableView.reloadData()
        }
        
        viewModel.getChildOptions = { [weak self] (options) in
            guard let loadedSectionIndex = self?.loadedSectionIndex else { return }
            self?.properties[loadedSectionIndex].child = options
            self?.searchTableView.reloadSections(IndexSet(integer: loadedSectionIndex + 2), with: .automatic)
        }
        
        viewModel.showError = { [weak self] (errorMessage) in
            self?.showAlert(title: "Error",message: errorMessage)
        }
    }
    
    private func getResults() -> [ResultModel] {
        guard selectedCategoryIndex != nil else { return []}
        var results: [ResultModel] = []
        if let selectedSubcategoryIndex = selectedSubcategoryIndex {
            results = [ResultModel(key: "Category", value: categories[selectedCategoryIndex!].name),
                       ResultModel(key: "Subcategory", value: categories[selectedCategoryIndex!].subcategories[selectedSubcategoryIndex].name)]
        }
        else if let selectedCategoryIndex = selectedCategoryIndex {
            results = [ResultModel(key: "Category", value: categories[selectedCategoryIndex].name)]
        }
        
        properties.forEach { (property) in
            if let selectedOptionIndex = property.selectedOptionIndex , selectedOptionIndex != -1 {
                results.append(ResultModel(key: property.name, value: property.options[selectedOptionIndex].name))
            }
            else if let otherValue = property.otherValue {
                results.append(ResultModel(key: property.name, value: otherValue))
            }
            
            property.child?.forEach({ (property) in
                if let selectedOptionIndex = property.selectedOptionIndex , selectedOptionIndex != -1  {
                    results.append(ResultModel(key: property.name, value: property.options[selectedOptionIndex].name))
                }
                else if let otherValue = property.otherValue {
                    results.append(ResultModel(key: property.name, value: otherValue))
                }
            })
        }
        return results
    }
    
    @objc private func handleRefreshControl(_ isRefreshing:Bool) {
        if isRefreshing {
            refreshControl.beginRefreshing()
            view.isUserInteractionEnabled = false
        } else {
            refreshControl.endRefreshing()
            view.isUserInteractionEnabled = true
        }
    }
    
    @objc private func handleRefresher() {
        refreshControl.endRefreshing()
    }
    
    private func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        let cell = searchTableView.dequeueCell(tabelViewCell: SearchInputTableViewCell.self, indexPath: indexPath)
        cell.setData(section: sections[indexPath.section])
        cell.reloadCellHeight = { [weak self] in
            self?.searchTableView.beginUpdates()
            self?.searchTableView.endUpdates()
        }
        switch sections[indexPath.section] {
        case .category:
            setupCategoryCell(cell: cell)
        case .subcategory:
            setupSubcategoryCell(cell: cell)
        case .option:
            setupOptionCell(cell: cell,indexPath: indexPath)
        }
        return cell as! t
    }
    
    private func setupCategoryCell(cell: SearchInputTableViewCell) {
        cell.setCategory(categories: categories,selectedCategoryindex: selectedCategoryIndex)
        cell.didSelectItem = { [weak self] (index) in
            guard index != self?.selectedCategoryIndex else { return }
            self?.selectedSubcategoryIndex = nil
            if let sectionIndex = SearchSections.allCases.firstIndex(where: {$0 == .subcategory}) {
                self?.searchTableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
            }
            self?.selectedCategoryIndex = index
        }
    }
    
    private func setupSubcategoryCell(cell: SearchInputTableViewCell) {
        if let selectedCategoryIndex = selectedCategoryIndex {
            cell.setSubcategory(subcategories: categories[selectedCategoryIndex].subcategories,selectedSubcategoryindex: selectedSubcategoryIndex)
        }
        cell.didSelectItem = { [weak self] (index) in
            guard self?.selectedSubcategoryIndex != index else { return }
            self?.selectedSubcategoryIndex = index
        }
    }
    
    private func setupOptionCell(cell: SearchInputTableViewCell,indexPath: IndexPath) {
        let section = indexPath.section - 2
        if let option = (indexPath.row == 0) ? properties[section] : properties[section].child?[indexPath.row - 1] {
            let showOther: Bool = (option.selectedOptionIndex == -1 && !option.options.isEmpty )
            cell.setOption(property: option,selectedOptionIndex: option.selectedOptionIndex, showOther: showOther)
        }
        
        cell.didSelectItem = { [weak self] (index) in
            self?.didSelectOption(indexPath: indexPath, index: index)
        }
        
        cell.setText = { [weak self] (value) in
            if indexPath.row == 0 {
                self?.properties[section].otherValue = value
            }
            else {
                self?.properties[section].child?[indexPath.row - 1].otherValue = value
            }
        }
    }
    
    private func didSelectOption(indexPath: IndexPath,index: Int) {
        
        if indexPath.row == 0 {
            // Main Prop
            updateMainOption(indexPath: indexPath, index: index)
        }
        else{
            updateChildOption(indexPath: indexPath, index: index)
        }
    }
    
    private func updateMainOption(indexPath: IndexPath,index: Int) {
        let section = indexPath.section - 2
        if (properties[section].options.count) > index {
            guard properties[section].selectedOptionIndex != index else { return }
            properties[section].selectedOptionIndex = index
            if (properties[section].options[index].child) {
                // get childs
                loadedSectionIndex = section
                viewModel.fetchChildOptions(propertyId: properties[section].options[index].id)
            }
        }
        else {
            // Other
            properties[section].selectedOptionIndex = -1
        }
        
        if !(properties[section].child?.isEmpty ?? true) {
            properties[section].child?.removeAll()
            searchTableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    private func updateChildOption(indexPath: IndexPath,index: Int) {
        let section = indexPath.section - 2
        // Child Prop
        if (properties[section].child?[indexPath.row - 1].options.count ?? 0) > index {
            properties[section].child?[indexPath.row - 1].selectedOptionIndex = index
        }
        else {
            // Other
            properties[section].child?[indexPath.row - 1].selectedOptionIndex = -1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultViewController {
            vc.results = getResults()
        }
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
