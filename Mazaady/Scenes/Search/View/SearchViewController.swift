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
        title = "Search..."
        
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
            DispatchQueue.main.async {
                self?.searchTableView.beginUpdates()
                self?.searchTableView.endUpdates()
            }
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
        
        cell.didStartEditing = { [weak self] in
            guard let strongSelf = self else { return }
            let selectionView = SelectionView.init(categories: strongSelf.categories,selectedCategoryIndex: strongSelf.selectedCategoryIndex)
            selectionView.setHeader(title: "Category")
            selectionView.type = .category
            selectionView.didFinishAction = { (isOpen) in
                if !isOpen {
                    cell.textFieldEndEditing()
                }
            }
            
            selectionView.didSelectItem = { [weak self] (index) in
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
                guard index != self?.selectedCategoryIndex else { return }
                cell.setSearchInput(index: index, text: self?.categories[index].name ?? "")
                self?.selectedSubcategoryIndex = nil
                if let sectionIndex = SearchSections.allCases.firstIndex(where: {$0 == .subcategory}) {
                    self?.searchTableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
                }
                self?.selectedCategoryIndex = index
            }
            
            selectionView.doneButtonClicked = {
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                strongSelf.view.bringSubviewToFront(selectionView)
                selectionView.performCardViewAnimation(state: true, isDeinit: false)
            }
        }
    }
    
    private func setupSubcategoryCell(cell: SearchInputTableViewCell) {
        if let selectedCategoryIndex = selectedCategoryIndex {
            cell.setSubcategory(subcategories: categories[selectedCategoryIndex].subcategories,selectedSubcategoryindex: selectedSubcategoryIndex)
        }
        
        cell.didStartEditing = { [weak self] in
            guard let strongSelf = self , let selectedCategoryIndex = strongSelf.selectedCategoryIndex else {
                cell.textFieldEndEditing()
                self?.showAlert(message: "Please select the category first")
                return
            }
            let selectionView = SelectionView.init(subcategories: strongSelf.categories[selectedCategoryIndex].subcategories,selectedSubcategoryIndex: strongSelf.selectedSubcategoryIndex)
            selectionView.setHeader(title: "Subcategory")
            selectionView.type = .subcategory
            selectionView.didFinishAction = { (isOpen) in
                if !isOpen {
                    cell.textFieldEndEditing()
                }
            }
            
            selectionView.didSelectItem = { [weak self] (index) in
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
                guard self?.selectedSubcategoryIndex != index else { return }
                cell.setSearchInput(index: index, text: self?.categories[index].name ?? "")
                self?.selectedSubcategoryIndex = index
            }
            
            selectionView.doneButtonClicked = {
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                strongSelf.view.bringSubviewToFront(selectionView)
                selectionView.performCardViewAnimation(state: true, isDeinit: false)
            }
        }
    }
    
    private func setupOptionCell(cell: SearchInputTableViewCell,indexPath: IndexPath) {
        let showOther: Bool = (viewModel.properties[indexPath.row].selectedOptionIndex == -1 && !viewModel.properties[indexPath.row].options.isEmpty )
        cell.setOption(property: viewModel.properties[indexPath.row],selectedOptionIndex: viewModel.properties[indexPath.row].selectedOptionIndex, showOther: showOther)
        
        cell.didStartEditing = { [weak self] in
            guard let strongSelf = self , !strongSelf.viewModel.properties[indexPath.row].options.isEmpty else { return }
            let selectionView = SelectionView.init(options: strongSelf.viewModel.properties[indexPath.row].options, selectedOptionIndex: strongSelf.viewModel.properties[indexPath.row].selectedOptionIndex)
            selectionView.setHeader(title: strongSelf.viewModel.properties[indexPath.row].name)
            selectionView.type = .option
            selectionView.didFinishAction = { (isOpen) in
                if !isOpen {
                    cell.textFieldEndEditing()
                }
            }
            
            selectionView.didSelectItem = { [weak self] (index) in
                if self?.viewModel.properties[indexPath.row].options.count == index {
                    cell.setSearchInput(index: index, text: "Other")
                    cell.textFieldEndEditing()
                    self?.updateProperty(indexPath: indexPath,index: index)
                }
                else if self?.viewModel.properties[indexPath.row].selectedOptionIndex != index {
                    cell.setSearchInput(index: index, text: self?.viewModel.properties[indexPath.row].options[index].name ?? "")
                    cell.textFieldEndEditing()
                    self?.updateProperty(indexPath: indexPath,index: index)
                }
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
            }
            
            selectionView.doneButtonClicked = {
                selectionView.performCardViewAnimation(state: false, isDeinit: false)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                strongSelf.view.bringSubviewToFront(selectionView)
                selectionView.performCardViewAnimation(state: true, isDeinit: false)
            }
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
