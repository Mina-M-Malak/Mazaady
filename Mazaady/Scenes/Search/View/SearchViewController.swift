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
            if !viewModel.properties.isEmpty{
                viewModel.properties.removeAll()
                searchTableView.reloadData()
            }
            else if let subcategorySectionIndex = SearchSections.allCases.firstIndex(where: {$0 == .subcategory}) {
                searchTableView.reloadRows(at: [IndexPath(row: 0, section: subcategorySectionIndex)], with: .automatic)
            }
        }
    }
    
    private var selectedSubcategoryIndex: Int?{
        didSet{
            guard let selectedCategoryIndex = selectedCategoryIndex , let selectedSubcategoryIndex = selectedSubcategoryIndex else { return }
            viewModel.properties.removeAll()
            searchTableView.reloadData()
            let subcategoryId = categories[selectedCategoryIndex].subcategories[selectedSubcategoryIndex].id
            viewModel.fetchProperties(subcategoryId: subcategoryId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.searchTableView.reloadData()
                case .failure(let err):
                    self?.showAlert(title: "Error",message: err)
                }
            }
        }
    }
    
    private var categories: [Category] = []{
        didSet{
            searchTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setObservers()
        fetchCategories()
    }
    
    private func setupUI() {
        title = "Search"
        
        refreshControl.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        
        searchTableView.refreshControl = refreshControl
        searchTableView.registerCell(tabelViewCell: SearchInputTableViewCell.self)
        
        searchTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setObservers() {
        viewModel.loadingState = { [weak self] (isLoading) in
            self?.handleRefreshControl(isLoading)
        }
        
        viewModel.didUpdateProperties = { [weak self] in
            self?.searchTableView.reloadData()
        }
    }
    
    private func fetchCategories() {
        viewModel.fetchCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure(let err):
                self?.showAlert(title: "Error",message: err)
            }
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
        
        viewModel.properties.forEach { (property) in
            if let selectedOptionIndex = property.selectedOptionIndex , selectedOptionIndex != -1 {
                results.append(ResultModel(key: property.name, value: property.options[selectedOptionIndex].name))
            }
            else if let otherValue = property.otherValue {
                results.append(ResultModel(key: property.name, value: otherValue))
            }
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
        cell.setData(section: SearchSections.allCases[indexPath.section])
        cell.reloadCellHeight = { [weak self] in
            self?.searchTableView.beginUpdates()
            self?.searchTableView.endUpdates()
        }
        switch SearchSections.allCases[indexPath.section] {
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
        let showOther: Bool = (viewModel.properties[indexPath.row].selectedOptionIndex == -1 && !viewModel.properties[indexPath.row].options.isEmpty )
        cell.setOption(property: viewModel.properties[indexPath.row],selectedOptionIndex: viewModel.properties[indexPath.row].selectedOptionIndex, showOther: showOther)
        
        cell.didSelectItem = { [weak self] (index) in
            self?.didSelectOption(indexPath: indexPath, index: index)
        }
        
        cell.setText = { [weak self] (value) in
            if indexPath.row == 0 {
                self?.viewModel.properties[indexPath.row].otherValue = value
            }
            else {
                self?.viewModel.properties[indexPath.row].otherValue = value
            }
        }
    }
    
    private func didSelectOption(indexPath: IndexPath,index: Int) {
        updateProperty(indexPath: indexPath,index: index)
    }
    
    private func updateProperty(indexPath: IndexPath,index: Int) {
        guard viewModel.properties[indexPath.row].selectedOptionIndex != index else { return }
        if (viewModel.properties[indexPath.row].options.count) > index {
            viewModel.properties[indexPath.row].selectedOptionIndex = index
        }
        else {
            // Other
            viewModel.properties[indexPath.row].selectedOptionIndex = -1
        }
        viewModel.didSelectProperty(propertyIndex: indexPath.row,optionIndex: index)
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
        return SearchSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SearchSections.allCases[section]{
        case .category , .subcategory:
            return 1
        case .option:
            return viewModel.properties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}
